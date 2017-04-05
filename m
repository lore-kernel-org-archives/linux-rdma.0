From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] IB/IPoIB: Rename qpn to be dqpn in
 ipoib_send and post_send functions
Date: Wed, 5 Apr 2017 15:00:48 +0000
Message-ID: <1491404447.2787.1.camel@sandisk.com>
References: <20170404191732.31895-5-leon@kernel.org>
         <201704050840.SLVNyMTT%fengguang.wu@intel.com>
         <20170405103838.GE20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405103838.GE20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <39520D9C4B7FDE4CA6E4E5CF1768C750-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-04-05 at 13:38 +0300, Leon Romanovsky wrote:
> On Wed, Apr 05, 2017 at 08:56:29AM +0800, kbuild test robot wrote:
> > Hi Erez,
> >=20
> > [auto build test ERROR on rdma/master]
> > [also build test ERROR on v4.11-rc5 next-20170404]
> > [if your patch is applied to the wrong git tree, please drop us a note =
to help improve the system]
>=20
> It should be applied to v4.11-rc3 and not to -rc5.

Hello Leon,

Will it be possible for Doug to apply this series to his tree without
rebasing this patch series on rc5 instead of rc3?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
