From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 16/21] srp_daemon: Do not use LOG_PERROR
Date: Tue, 25 Jul 2017 23:50:51 +0000
Message-ID: <1501026650.8931.11.camel@wdc.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500926429-31822-17-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501001276.8931.1.camel@wdc.com>
         <20170725171735.GC3164@obsidianresearch.com>
         <1501003688.8931.6.camel@wdc.com>
         <20170725174441.GB10905@obsidianresearch.com>
         <1501006185.8931.7.camel@wdc.com>
         <20170725230802.GA20499@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170725230802.GA20499-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <CD4F4740E35ED646A209D5E2D68D2FA8-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-07-25 at 17:08 -0600, Jason Gunthorpe wrote:
> On Tue, Jul 25, 2017 at 06:09:46PM +0000, Bart Van Assche wrote:
> > That sounds fine to me.
>=20
> Okay, I dropped the perror patch and replaced it with these two:
>=20
> https://github.com/linux-rdma/rdma-core/pull/172/commits/f1f2e1b1bc3e90ab=
dacdd06b3afe7ca4b107f9e3
> https://github.com/linux-rdma/rdma-core/pull/172/commits/588c60a33ac5b846=
fee039a1cb8e622681fb980e
>=20
> To implement a --systemd option to control the log behavior.

Hello Jason,

Since both is_systemd() and get_config() ignore the local variable opt_idx,
how about passing NULL as the fifth argument to getopt_long()?

>From the getopt_long() man page: "The variable optind is the index of the
next element to be processed in argv. The system initializes this value to
1. The caller can reset it to 1 to restart scanning of the same argv, or
when scanning a new argument vector."

Since getopt_long() is called twice by srp_daemon, shouldn't get_config()
reset the optind global variable before calling getopt_long()?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
