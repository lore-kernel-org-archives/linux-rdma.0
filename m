From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Tue, 10 Dec 2013 22:30:46 +0000
Message-ID: <25531352-B344-401C-AD6C-A48454B7B1A4@cisco.com>
References: <CAL1RGDXCGkfUf00Y+V9mZrmJ+aHVnTdmy4+pnLrMGoFTU9Cm3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXCGkfUf00Y+V9mZrmJ+aHVnTdmy4+pnLrMGoFTU9Cm3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <35305CF4F3A4C94980B6DD53EACAEAEE-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,
	All the values don't have to be in one file.  We can have one value per file; we thought it wouldn't be efficent to have one value per file bc 1) these values are related and 2) it is socially acceptable to have multiple values per file.  Some of these provide critical information about the qp, such as its state, while other things are not so critical such as VF Idx.  We thought it just made sense to also give out the other fields sitting on struct qp_grp while we were giving out the critical ones.  

Thoughts?

Upinder

On Dec 10, 2013, at 1:25 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> On Mon, Sep 9, 2013 at 8:38 PM, Upinder Malhi (umalhi) <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>> +static ssize_t summary_show(struct usnic_ib_qp_grp *qp_grp, char *buf)
>> +{
>> +       int i, j, n;
>> +       int left;
>> +       char *ptr;
>> +       struct usnic_vnic_res_chunk *res_chunk;
>> +       struct usnic_fwd_filter_hndl *default_filter_hndl;
>> +       struct usnic_vnic_res *vnic_res;
>> +
>> +       left = PAGE_SIZE;
>> +       ptr = buf;
>> +       default_filter_hndl = list_first_entry(&qp_grp->filter_hndls,
>> +                                       struct usnic_fwd_filter_hndl, link);
>> +
>> +       n = scnprintf(ptr, left,
>> +                       "QPN: %d State: (%s) PID: %u VF Idx: %hu Filter ID: 0x%x ",
>> +                       qp_grp->ibqp.qp_num,
>> +                       usnic_ib_qp_grp_state_to_string(qp_grp->state),
>> +                       qp_grp->owner_pid,
>> +                       usnic_vnic_get_index(qp_grp->vf->vnic),
>> +                       default_filter_hndl->id);
>> +       UPDATE_PTR_LEFT(n, ptr, left);
>> +
>> +       for (i = 0; qp_grp->res_chunk_list[i]; i++) {
>> +               res_chunk = qp_grp->res_chunk_list[i];
>> +               for (j = 0; j < res_chunk->cnt; j++) {
>> +                       vnic_res = res_chunk->res[j];
>> +                       n = scnprintf(ptr, left, "%s[%d] ",
>> +                               usnic_vnic_res_type_to_str(vnic_res->type),
>> +                               vnic_res->vnic_idx);
>> +                       UPDATE_PTR_LEFT(n, ptr, left);
>> +               }
>> +       }
>> +
>> +       n = scnprintf(ptr, left, "\n");
>> +       UPDATE_PTR_LEFT(n, ptr, left);
>> +
>> +       return ptr - buf;
>> +}
> 
> I thought the rule was one value per file in sysfs?  Is this debugging
> info that belongs in debugfs?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
