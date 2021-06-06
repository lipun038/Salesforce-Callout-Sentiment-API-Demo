import { LightningElement } from 'lwc';
import findSentiment from '@salesforce/apex/SentimentAnalysis.findSentiment';
export default class SentimentAnalysis extends LightningElement {
    isSpinner = false;
    strFeedback;
    strSentiment;
    error;
    handleOnchange(event){
        this[event.target.name] = event.target.value;
    }
    fetchSentiment(event){
        if(this.strFeedback){
            this.isSpinner = true;
            this.strSentiment = undefined;
            findSentiment({ msg : this.strFeedback})
                .then(result => {
                    this.strSentiment = result;
                    this.error = undefined;
                    this.isSpinner = false;
                })
                .catch(error => {
                    this.error = JSON.stringify(error);
                    this.strSentiment = undefined;
                    this.isSpinner = false;
                });
        }else{
            this.error = 'Please provide value in experience field';
            this.strSentiment = undefined;    
        }
    }
}