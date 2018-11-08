From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH net-next 0/4] Remove VLAN_TAG_PRESENT from
	drivers
Date: Thu, 8 Nov 2018 20:50:05 +0200
Message-ID: <20181108185005.GR3695@mtr-leonro.mtl.com>
References: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6959294842133827501=="
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <cover.1541698641.git.mirq-linux-CoA6ZxLDdyEEUmgCuDUIdw@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux-CoA6ZxLDdyEEUmgCuDUIdw@public.gmane.org>
Cc: dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Claudiu Manoil <claudiu.manoil-3arQi8VN3Tc@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--===============6959294842133827501==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ahP6B03r4gLOj5uD"
Content-Disposition: inline


--ahP6B03r4gLOj5uD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 08, 2018 at 06:44:46PM +0100, Micha=C5=82 Miros=C5=82aw wrote:
> This series removes VLAN_TAG_PRESENT use from network drivers in
> preparation to removing its special meaning.

Can you please give an extra explanation why it is removed?
Such series come out-of-blue, for people who are not following
netdev mailing list closely (drivers/infiniband/*).

Thanks

>
> Micha=C5=82 Miros=C5=82aw (4):
>   i40iw: remove use of VLAN_TAG_PRESENT
>   cnic: remove use of VLAN_TAG_PRESENT
>   gianfar: remove use of VLAN_TAG_PRESENT
>   OVS: remove use of VLAN_TAG_PRESENT
>
>  drivers/infiniband/hw/i40iw/i40iw_cm.c        |  8 +++----
>  drivers/net/ethernet/broadcom/cnic.c          |  2 +-
>  .../net/ethernet/freescale/gianfar_ethtool.c  |  8 +++----
>  net/openvswitch/actions.c                     | 13 +++++++----
>  net/openvswitch/flow.c                        |  4 ++--
>  net/openvswitch/flow.h                        |  2 +-
>  net/openvswitch/flow_netlink.c                | 22 +++++++++----------
>  7 files changed, 31 insertions(+), 28 deletions(-)
>
> --
> 2.19.1
>

--ahP6B03r4gLOj5uD--

--===============6959294842133827501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6959294842133827501==--
