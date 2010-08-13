From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/3 v4] IB/srp: Implement SRP_CRED_REQ
Date: Fri, 13 Aug 2010 16:02:17 -0400
Message-ID: <1281729737.2437.149.camel@lap75545.ornl.gov>
References: <201008102033.57038.bvanassche@acm.org>
 <1281729320.2437.142.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1281729320.2437.142.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2010-08-13 at 15:55 -0400, David Dillow wrote:
> On Tue, 2010-08-10 at 20:33 +0200, Bart Van Assche wrote:
> > Implements SRP_CRED_REQ, which is an information unit defined in the SRP
> > (draft) standard and that allows an SRP target to inform an SRP initiator that
> > more requests may be sent by the initiator. Adds declarations for the
> > SRP_CRED_REQ and SRP_CRED_RSP information units to include/scsi/srp.h.
> 
> Compile tested only

Indeed, I broke it.

> --- a/include/scsi/srp.h
> +++ b/include/scsi/srp.h
> @@ -237,6 +237,44 @@ struct srp_rsp {
>  	__be32	sense_data_len;
>  	__be32	resp_data_len;
>  	u8	data[0];
> +};
> +

Oops, accidentally removed __attribute__((packed)) from struct srp_rsp.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
