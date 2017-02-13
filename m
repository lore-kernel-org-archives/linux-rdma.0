From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Sun, 12 Feb 2017 21:07:16 -0500 (EST)
Message-ID: <655392767.30136125.1486951636415.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <20170210235611.3243-9-bart.vanassche@sandisk.com> <20170212171928.GF14015@mtr-leonro.local> <1041506550.30101266.1486922573298.JavaMail.zimbra@redhat.com> <1486929901.2918.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486929901.2918.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Sunday, February 12, 2017 3:05:16 PM
> Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
> 
> On Sun, 2017-02-12 at 13:02 -0500, Laurence Oberman wrote:
> > [  861.143141] WARNING: CPU: 27 PID: 1103 at
> > drivers/infiniband/core/verbs.c:1959 __ib_drain_sq+0x1bb/0x1c0 [ib_core]
> > [  861.202208] IB_POLL_DIRECT poll_ctx not supported for drain
> 
> Hello Laurence,
> 
> That warning has been removed by patch 7/8 of this series. Please double
> check
> whether all eight patches have been applied properly.
> 
> Bart.N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��

Hello 
Just a heads up, working with Bart on this patch series.
We have stability issues with my tests in my MLX5 EDR-100 test bed. 
Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
