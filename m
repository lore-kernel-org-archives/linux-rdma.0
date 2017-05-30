From: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Tue, 30 May 2017 20:03:58 +0200
Message-ID: <20170530180357.GB24898@nanopsycho>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-3-leon@kernel.org>
 <20170530073352.GA1838@nanopsycho>
 <20170530075845.GA5406@mtr-leonro.local>
 <20170530081514.GB1838@nanopsycho>
 <20170530172259.GD5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530172259.GD5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tue, May 30, 2017 at 07:22:59PM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>On Tue, May 30, 2017 at 10:15:14AM +0200, Jiri Pirko wrote:
>> Tue, May 30, 2017 at 09:58:45AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>> >On Tue, May 30, 2017 at 09:33:52AM +0200, Jiri Pirko wrote:
>> >> Tue, May 30, 2017 at 09:15:58AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>> >> >From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >> >
>> >> >Enable QP creation which is associated to underlay QP. This comes as a
>> >> >pre-patch for downstream patches in this series to enable flow steering
>> >> >from user space application on the underlay IPoIB QP.
>> >> >
>> >> >Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >> >Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>> >> >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> >> >---
>> >>
>> >> [...]
>> >>
>> >>
>> >> >diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
>> >> >index 477d629f539d..422b20456975 100644
>> >> >--- a/include/uapi/rdma/ib_user_verbs.h
>> >> >+++ b/include/uapi/rdma/ib_user_verbs.h
>> >> >@@ -578,7 +578,7 @@ struct ib_uverbs_ex_create_qp {
>> >> > 	__u32 comp_mask;
>> >> > 	__u32 create_flags;
>> >> > 	__u32 rwq_ind_tbl_handle;
>> >> >-	__u32  reserved1;
>> >> >+	__u32  associated_qpn;
>> >>
>> >> This breaks uapi...
>> >
>> >Not really, we are using comp_mask scheme to signal changes/predecessor
>> >of these structs. Users of this file and structs check comp_mask and
>> >access new fields only if they are exposed there.
>> >
>> >In this case, there are no users of reserved1 and hence it can be
>> >replace to the new field with corresponding comp_mask flag (IB_QP_CREATE_ASSOC_QPN)
>> >without worry of breakage.
>>
>> I, as an app could include ib_user_verbs.h and do:
>>
>> struct ib_uverbs_ex_create_qp something;
>>
>> something.reserved1 = 0;
>>
>> Than I won't compile, would I?
>
>You are right, the good thing that in IB world, there is no direct usage
>of these files and they are needed for rdma-core (libibverbs) library.

Unfortunatelly, that does not make any difference. UAPI is UAPI...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
