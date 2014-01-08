From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 4/9] IB/usnic: Fix error handling with
 IS_ERR_OR_NULL
Date: Wed, 8 Jan 2014 00:11:02 +0000
Message-ID: <03E95B5A-4394-451C-969C-A869D8EDF345@cisco.com>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com>
 <1387298917-7365-5-git-send-email-umalhi@cisco.com>
 <52B566A9.1080908@acm.org> <3A32A946-EB43-4609-A04A-3BB846C442DB@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3A32A946-EB43-4609-A04A-3BB846C442DB-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <34A6B7028AA2DF4DBEE3F3A6D9BB825C-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looking through the usNIC code, it uses the below notation everywhere in the code.  Hence, I will not change the below patch, so the notation is consistent with rest of the code and will get rid of all of the extraneous parentheses in another cosmetic patch.

Upinder


On Jan 7, 2014, at 2:03 PM, Upinder Malhi (umalhi) <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> Ack.  Will comply.
> 
> Upinder
> 
> On Dec 21, 2013, at 2:00 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> 
>> On 12/17/13 17:48, Upinder Malhi wrote:
>>> Errors with IS_ERR_OR_NULL are not handleded correctly in few places
>>> in usNIC.  This patch remedies that.
>>> 
>>> Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>>> ---
>>> drivers/infiniband/hw/usnic/usnic_ib_main.c  | 10 ++++++----
>>> drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  2 +-
>>> 2 files changed, 7 insertions(+), 5 deletions(-)
>>> 
>>> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
>>> index 4d8cadc..7200861 100644
>>> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
>>> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
>>> @@ -398,13 +398,14 @@ static struct usnic_ib_dev *usnic_ib_discover_pf(struct usnic_vnic *vnic)
>>> 
>>> 	us_ibdev = usnic_ib_device_add(parent_pci);
>>> 	if (IS_ERR_OR_NULL(us_ibdev)) {
>>> -		us_ibdev = ERR_PTR(-EINVAL);
>>> +		us_ibdev = (us_ibdev) ? us_ibdev : ERR_PTR(-EFAULT);
>>> 		goto out;
>>> 	}
>>> 
>>> 	err = usnic_ib_sysfs_register_usdev(us_ibdev);
>>> 	if (err) {
>>> 		usnic_ib_device_remove(us_ibdev);
>>> +		us_ibdev = ERR_PTR(err);
>>> 		goto out;
>>> 	}
>>> 
>>> @@ -459,9 +460,10 @@ int usnic_ib_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>> 	}
>>> 
>>> 	pf = usnic_ib_discover_pf(vf->vnic);
>>> -	if (!pf) {
>>> -		usnic_err("Failed to discover pf of vnic %s with err%d\n",
>>> -				pci_name(pdev), err);
>>> +	if (IS_ERR_OR_NULL(pf)) {
>>> +		usnic_err("Failed to discover pf of vnic %s with err%ld\n",
>>> +				pci_name(pdev), PTR_ERR(pf));
>>> +		err = (pf ? PTR_ERR(pf) : -EFAULT);
>>> 		goto out_clean_vnic;
>>> 	}
>>> 
>>> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
>>> index d305e4e..e19ca90 100644
>>> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
>>> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
>>> @@ -574,7 +574,7 @@ struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
>>> 	mr->umem = usnic_uiom_reg_get(to_upd(pd)->umem_pd, start, length,
>>> 					access_flags, 0);
>>> 	if (IS_ERR_OR_NULL(mr->umem)) {
>>> -		err = PTR_ERR(mr->umem);
>>> +		err = (mr->umem) ? PTR_ERR(mr->umem) : -EFAULT;
>>> 		goto err_free;
>>> 	}
>> 
>> Three out of four of the above changes introduce superfluous
>> parentheses. Please do not introduce superfluous parentheses that do not
>> improve readability.
>> 
>> Bart.
>> 
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
