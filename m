From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Fri, 12 Jan 2018 19:09:37 -0500
Message-ID: <1515802177.1566.1.camel@redhat.com>
References: <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
         <1515612639.10153.3.camel@redhat.com> <20180110205243.GP4776@mellanox.com>
         <1515618674.10153.6.camel@redhat.com> <20180110211501.GS4776@mellanox.com>
         <1515675741.21421.1.camel@redhat.com> <1515703435.21421.9.camel@redhat.com>
         <1515705340.2752.60.camel@wdc.com> <1515706433.21421.11.camel@redhat.com>
         <1515791472.2396.57.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515791472.2396.57.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2018-01-12 at 21:11 +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 16:33 -0500, Laurence Oberman wrote:
> > I just rebooted the server into 4.13 and its fine again and found
> > all
> > the targets with the same kernel on the client.
> > 
> > So its specific to your new tree with srpt
> > 
> > I will reboot again and re-load LIO and show you but here is my ACL
> > list that has been this way for some time.
> > 
> > 
> > o- srpt
> > ...................................................................
> > ....
> > ...................................... [Targets: 2]
> >   | o- ib.fe800000000000007cfe900300726e4e
> > ...................................................................
> > ....
> > .... [no-gen-acls]
> >   | | o- acls
> > ...................................................................
> > ....
> > ..................................... [ACLs: 8]
> >   | | | o- ib.4e6e72000390fe7c7cfe900300726ed2
> > 
> > [ ... ]
> 
> Hello Laurence,
> 
> Although I'm not sure I think I found the root cause of this failure.
> The
> following patch should fix the failure:
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
> b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 96142110a155..5297963c834d 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2083,7 +2083,7 @@ static int srpt_cm_req_recv(struct srpt_device
> *const sdev,
>  		struct ib_cm_rep_param ib_cm;
>  	} *rep_param = NULL;
>  	struct srpt_rdma_ch *ch;
> -	char i_port_id[24];
> +	char i_port_id[36];
>  	u32 it_iu_len;
>  	int i, ret;
>  
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h
> b/drivers/infiniband/ulp/srpt/ib_srpt.h
> index bf4525b24d98..02883f8e9c71 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -308,7 +308,7 @@ struct srpt_rdma_ch {
>  	bool			using_rdma_cm;
>  	bool			processing_wait_list;
>  	struct se_session	*sess;
> -	u8			sess_name[36];
> +	u8			sess_name[24];
>  	struct work_struct	release_work;
>  };
>  
> 
> I wrote "should" because targetcli is not installed on my test setup
> and
> because I have not yet verified this change with targetcli. If you
> have the
> time to verify this change that would be great. If not then I will
> install
> targetcli myself and verify this change.
> 
> Thanks,
> 
> Bart.NrybXǧv^)޺{.n+{ٚ{ay
ʇڙ,jfhz
w
j:+vwjmzZ+ݢj"!


Hi Bart

I will get this tested tonight and report back.

Fix makes sesne.

Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
