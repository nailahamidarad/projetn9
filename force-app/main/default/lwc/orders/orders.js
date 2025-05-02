import { LightningElement, api } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/OrdersController.getSumOrdersByAccount';

export default class Orders extends LightningElement {
    @api recordId;
    sumOrdersOfCurrentAccount = 0;

    connectedCallback() {
        this.fetchSumOrders();
    }

    fetchSumOrders() {
        if (this.recordId) {
            getSumOrdersByAccount({ accountId: this.recordId })
                .then(result => {
                    this.sumOrdersOfCurrentAccount = result;
                })
                .catch(error => {
                    console.error('Erreur lors de la récupération des commandes : ', error);
                    this.sumOrdersOfCurrentAccount = 0;
                });
        } else {
            console.warn('recordId non défini');
            this.sumOrdersOfCurrentAccount = 0;
        }
    }

    get hasError() {
        return !this.sumOrdersOfCurrentAccount || this.sumOrdersOfCurrentAccount <= 0;
    }
}
