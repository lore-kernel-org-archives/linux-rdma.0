From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 3/9] selinux lsm IB/core: Implement LSM notification
 system
Date: Tue, 8 Nov 2016 23:41:02 +0000
Message-ID: <VI1PR0501MB2429F6023D7A33A5F4FF2728C4A60@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <201611090600.BYNmwuAI%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/8/2016 4:36 PM, kbuild test robot wrote:=0A=
> Hi Daniel,=0A=
>=0A=
> [auto build test ERROR on rdma/master]=0A=
> [also build test ERROR on v4.9-rc4]=0A=
> [cannot apply to next-20161108]=0A=
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]=0A=
>=0A=
> url:    https://github.com/0day-ci/linux/commits/Dan-Jurgens/SELinux-supp=
ort-for-Infiniband-RDMA/20161109-053432=0A=
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git=
 master=0A=
> config: i386-randconfig-s1-201645 (attached as .config)=0A=
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901=0A=
> reproduce:=0A=
>         # save the attached .config to linux build tree=0A=
>         make ARCH=3Di386 =0A=
>=0A=
> All errors (new ones prefixed by >>):=0A=
>=0A=
>>> ERROR: "unregister_lsm_notifier" [drivers/infiniband/core/ib_core.ko] u=
ndefined!=0A=
>>> ERROR: "register_lsm_notifier" [drivers/infiniband/core/ib_core.ko] und=
efined!=0A=
> ---=0A=
> 0-DAY kernel test infrastructure                Open Source Technology Ce=
nter=0A=
> https://lists.01.org/pipermail/kbuild-all                   Intel Corpora=
tion=0A=
=0A=
This link error happens when CONFIG_SECURITY is not set.  I will address it=
 in v5 after giving some time for additional comments.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
