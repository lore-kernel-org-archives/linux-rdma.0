From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Mon, 24 Apr 2017 18:59:34 -0400 (EDT)
Message-ID: <1523612139.1427604.1493074774861.JavaMail.zimbra@redhat.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com> <1726285260.1422143.1493073573791.JavaMail.zimbra@redhat.com> <1493073989.3394.24.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493073989.3394.24.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
> sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
> Sent: Monday, April 24, 2017 6:46:30 PM
> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> 
> On Mon, 2017-04-24 at 18:39 -0400, Laurence Oberman wrote:
> > Will get this tested this week,
> 
> Thanks Laurence. BTW, if you want to test this patch with the SRP protocol
> you will also have to revert commit d6c58dc40fec ("IB/SRP: Avoid using
> IB_MR_TYPE_SG_GAPS"). The code path touched by this patch is namely only
> relevant for IB_MR_TYPE_SG_GAPS memory regions. Currently the SRP initiator
> driver does not use that MR type. Reverting the aforementioned commit will
> make the SRP initiator driver use that MR type.
> 
> Please also apply Sagi's "mlx5: Fix mlx5_ib_map_mr_sg mr length" patch
> before starting any tests.
> 
> Thanks,
> 
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Understood
Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
