From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 5/7] IB/rxe: Fix destination cache for IPv6
Date: Thu, 27 Jul 2017 13:24:15 +0000
Message-ID: <D59F6117.1B7FD%Andrew.Boyer@emc.com>
References: <1500989968-30889-6-git-send-email-andrew.boyer@dell.com>
 <201707271425.T94Zam4o%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201707271425.T94Zam4o%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <97F8C287B5F06640A7C0B29AFCA60B5B-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hubbe, Allen" <Allen.Hubbe-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks like I forgot to check for CONFIG_IPV6.

On 7/27/17, 2:41 AM, "kbuild test robot" <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>Hi Andrew,
>
>[auto build test ERROR on rdma/master]
>[also build test ERROR on v4.13-rc2 next-20170726]
>[if your patch is applied to the wrong git tree, please drop us a note to
>help improve the system]
>
>url:   =20
>https://github.com/0day-ci/linux/commits/Andrew-Boyer/IB-rxe-Move-refcount
>ing-earlier-in-rxe_send/20170726-141937
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
>master
>config: i386-randconfig-i1-07240017 (attached as .config)
>compiler: gcc-4.8 (Debian 4.8.4-1) 4.8.4
>reproduce:
>        # save the attached .config to linux build tree
>        make ARCH=3Di386
>
>All errors (new ones prefixed by >>):
>
>   drivers/infiniband//sw/rxe/rxe_net.c: In function 'rxe_find_route':
>>> drivers/infiniband//sw/rxe/rxe_net.c:214:6: error: implicit
>>>declaration of function 'rt6_get_cookie'
>>>[-Werror=3Dimplicit-function-declaration]
>         rt6_get_cookie((struct rt6_info *)dst);
>         ^
>   cc1: some warnings being treated as errors
>
>vim +/rt6_get_cookie +214 drivers/infiniband//sw/rxe/rxe_net.c
>
>   184=09
>   185	static struct dst_entry *rxe_find_route(struct rxe_dev *rxe,
>   186						struct rxe_qp *qp,
>   187						struct rxe_av *av)
>   188	{
>   189		struct dst_entry *dst =3D NULL;
>   190=09
>   191		if (qp_type(qp) =3D=3D IB_QPT_RC)
>   192			dst =3D sk_dst_get(qp->sk->sk);
>   193=09
>   194		if (!dst || !dst_check(dst, qp->dst_cookie)) {
>   195			if (dst)
>   196				dst_release(dst);
>   197=09
>   198			if (av->network_type =3D=3D RDMA_NETWORK_IPV4) {
>   199				struct in_addr *saddr;
>   200				struct in_addr *daddr;
>   201=09
>   202				saddr =3D &av->sgid_addr._sockaddr_in.sin_addr;
>   203				daddr =3D &av->dgid_addr._sockaddr_in.sin_addr;
>   204				dst =3D rxe_find_route4(rxe->ndev, saddr, daddr);
>   205			} else if (av->network_type =3D=3D RDMA_NETWORK_IPV6) {
>   206				struct in6_addr *saddr6;
>   207				struct in6_addr *daddr6;
>   208=09
>   209				saddr6 =3D &av->sgid_addr._sockaddr_in6.sin6_addr;
>   210				daddr6 =3D &av->dgid_addr._sockaddr_in6.sin6_addr;
>   211				dst =3D rxe_find_route6(rxe->ndev, saddr6, daddr6);
>   212				if (dst)
>   213					qp->dst_cookie =3D
> > 214						rt6_get_cookie((struct rt6_info *)dst);
>   215			}
>   216		}
>   217=09
>   218		return dst;
>   219	}
>   220=09
>
>---
>0-DAY kernel test infrastructure                Open Source Technology
>Center
>https://lists.01.org/pipermail/kbuild-all                   Intel
>Corporation

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
