import { LightningElement, api } from 'lwc';
// TODO - récupérer la méthode apex permettant de faire ce calcul

export default class Orders extends LightningElement {

    sumOrdersOfCurrentAccount;
    @api recordId;

    connectedCallback() {
        this.fetchSumOrders();
    }

    fetchSumOrders() {
        // TODO - récupérer le montant total des Orders sur le compte avec la méthode apex
    }
}