From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH libibverbs v3 1/3] Add new call ibv_cmd_create_ah_ex
 which supports extra parameters
Date: Tue, 20 Sep 2016 16:29:45 +0300
Message-ID: <20160920132945.GO26673@leon.nu>
References: <cover.b0b7418bec346c028215053b3e58e097aa822563.1474352400.git-series.knut.omang@oracle.com>
 <d551c3792e884443903c67212f505082cd53b135.1474352400.git-series.knut.omang@oracle.com>
 <550041ef-b105-c079-068c-d96278ec34f1@dev.mellanox.co.il>
 <1474371459.8837.32.camel@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OAiy6VLsECigG9dy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474371459.8837.32.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--OAiy6VLsECigG9dy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2016 at 01:37:39PM +0200, Knut Omang wrote:
> On Tue, 2016-09-20 at 14:17 +0300, Yishai Hadas wrote:
> > On 9/20/2016 9:22 AM, Knut Omang wrote:
> > >
> > > The original call ibv_cmd_create_ah does not allow vendor specific re=
quest or
> > > response parameters to be defined and passed through to kernel space.
> > >
> > > To keep backward compatibility, introduce a new extended call which a=
ccepts
> > > cmd and resp parameters similar to other parts of the API.
> > > Reimplement the old call to just use the new extended call.
> > >
> > > The new call is versioned in the shared library as IBVERBS_1.4.
> > >
> > > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > =A0include/infiniband/driver.h |=A0=A04 +++-
> > > =A0src/cmd.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
| 50 +++++++++++++++++++++-----------------
> > > =A0src/libibverbs.map=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A06 ++++-
> > > =A03 files changed, 37 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
> > > index ea3dade..9356dc8 100644
> > > --- a/include/infiniband/driver.h
> > > +++ b/include/infiniband/driver.h
> > > @@ -234,6 +234,10 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, s=
truct ibv_recv_wr *wr,
> > > =A0			=A0=A0struct ibv_recv_wr **bad_wr);
> > > =A0int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
> > > =A0		=A0=A0=A0=A0=A0=A0struct ibv_ah_attr *attr);
> > > +int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah,
> > > +			struct ibv_ah_attr *attr,
> > > +			struct ibv_create_ah *cmd, size_t cmd_size,
> > > +			struct ibv_create_ah_resp *resp, size_t resp_size);
> > > =A0int ibv_cmd_destroy_ah(struct ibv_ah *ah);
> > > =A0int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *g=
id, uint16_t lid);
> > > =A0int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *g=
id, uint16_t lid);
> > > diff --git a/src/cmd.c b/src/cmd.c
> > > index 11f6509..58b9dcd 100644
> > > --- a/src/cmd.c
> > > +++ b/src/cmd.c
> > > @@ -1493,38 +1493,44 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq=
, struct ibv_recv_wr *wr,
> > > =A0	return ret;
> > > =A0}
> > >
> > > -int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
> > > -		=A0=A0=A0=A0=A0=A0struct ibv_ah_attr *attr)
> > > +int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah, struc=
t ibv_ah_attr *attr,
> > > +			=A0struct ibv_create_ah *cmd, size_t cmd_size,
> > > +			=A0struct ibv_create_ah_resp *resp, size_t resp_size)
> > > =A0{
> > > -	struct ibv_create_ah=A0=A0=A0=A0=A0=A0cmd;
> > > -	struct ibv_create_ah_resp resp;
> > > -
> > > -	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, CREATE_AH, &resp, sizeof resp);
> > > -	cmd.user_handle=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D (uintptr_t) =
ah;
> > > -	cmd.pd_handle=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D pd->hand=
le;
> > > -	cmd.attr.dlid=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D attr->dl=
id;
> > > -	cmd.attr.sl=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D attr=
->sl;
> > > -	cmd.attr.src_path_bits=A0=A0=A0=A0=A0=3D attr->src_path_bits;
> > > -	cmd.attr.static_rate=A0=A0=A0=A0=A0=A0=A0=3D attr->static_rate;
> > > -	cmd.attr.is_global=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D attr->is_global;
> > > -	cmd.attr.port_num=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D attr->port_num;
> > > -	cmd.attr.grh.flow_label=A0=A0=A0=A0=3D attr->grh.flow_label;
> > > -	cmd.attr.grh.sgid_index=A0=A0=A0=A0=3D attr->grh.sgid_index;
> > > -	cmd.attr.grh.hop_limit=A0=A0=A0=A0=A0=3D attr->grh.hop_limit;
> > > -	cmd.attr.grh.traffic_class =3D attr->grh.traffic_class;
> > > -	memcpy(cmd.attr.grh.dgid, attr->grh.dgid.raw, 16);
> > > +	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_AH, resp, resp_size);
> > > +	cmd->user_handle=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D (uintptr_t)=
 ah;
> > > +	cmd->pd_handle=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D pd->han=
dle;
> > > +	cmd->attr.dlid=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D attr->d=
lid;
> > > +	cmd->attr.sl=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D att=
r->sl;
> > > +	cmd->attr.src_path_bits=A0=A0=A0=A0=A0=3D attr->src_path_bits;
> > > +	cmd->attr.static_rate=A0=A0=A0=A0=A0=A0=A0=3D attr->static_rate;
> > > +	cmd->attr.is_global=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D attr->is_global;
> > > +	cmd->attr.port_num=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=3D attr->port_num;
> > > +	cmd->attr.grh.flow_label=A0=A0=A0=A0=3D attr->grh.flow_label;
> > > +	cmd->attr.grh.sgid_index=A0=A0=A0=A0=3D attr->grh.sgid_index;
> > > +	cmd->attr.grh.hop_limit=A0=A0=A0=A0=A0=3D attr->grh.hop_limit;
> > > +	cmd->attr.grh.traffic_class =3D attr->grh.traffic_class;
> > > +	memcpy(cmd->attr.grh.dgid, attr->grh.dgid.raw, 16);
> > >
> > > -	if (write(pd->context->cmd_fd, &cmd, sizeof cmd) !=3D sizeof cmd)
> > > +	if (write(pd->context->cmd_fd, cmd, cmd_size) !=3D cmd_size)
> > > =A0		return errno;
> > >
> > > -	(void) VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
> > > +	(void) VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
> > >
> > > -	ah->handle=A0=A0=3D resp.handle;
> > > +	ah->handle=A0=A0=3D resp->handle;
> > > =A0	ah->context =3D pd->context;
> > >
> > > =A0	return 0;
> > > =A0}
> > >
> > > +int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
> > > +		=A0=A0=A0=A0=A0=A0struct ibv_ah_attr *attr)
> > > +{
> > > +	struct ibv_create_ah=A0=A0=A0=A0=A0=A0cmd;
> > > +	struct ibv_create_ah_resp resp;
> > > +	return ibv_cmd_create_ah_ex(pd, ah, attr, &cmd, sizeof(cmd), &resp,=
 sizeof(resp));
> > > +}
> > > +
> > > =A0int ibv_cmd_destroy_ah(struct ibv_ah *ah)
> > > =A0{
> > > =A0	struct ibv_destroy_ah cmd;
> > > diff --git a/src/libibverbs.map b/src/libibverbs.map
> > > index 46744e5..ddba63a 100644
> > > --- a/src/libibverbs.map
> > > +++ b/src/libibverbs.map
> > > @@ -118,7 +118,6 @@ IBVERBS_1.1 {
> > > =A0		ibv_cmd_create_qp_ex2;
> > > =A0		ibv_cmd_open_qp;
> > > =A0		ibv_cmd_rereg_mr;
> > > -
> > > =A0} IBVERBS_1.0;
> > >
> > > =A0IBVERBS_1.3 {
> > > @@ -130,3 +129,8 @@ IBVERBS_1.3 {
> > > =A0		ibv_cmd_destroy_rwq_ind_table;
> > > =A0		ibv_query_gid_type;
> > > =A0} IBVERBS_1.1;
> > > +
> > > +IBVERBS_1.4 {
> > Any reason to add 1.4 instead of using 1.3 ? in my understanding the=A0
> > idea is that new symbols for next release will use a new ABI version,=A0
> > this is what 1.3 already supplied. Added Jason for his input as well.
>
> good point - Jason?
>
> > >
> > > +	global:
> > > +		ibv_cmd_create_ah_ex;
> > When do you plan to contribute the driver code for that ? for now no=A0
> > upstream drivers uses this API, taking some code for future usage with=
=A0
> > no current usage is not the preferred way.
>
> The plan is ASAP, the kernel side has been approved for release by Oracle=
's
> legal dep, but the user library is still stuck, and with an undesirable
> license combination given Jason's recent consolidation efforts :-/

Jason didn't change licenses. You still can release your driver under
dual-license in similar way to other drivers.

>
> Knut
>
> > >
> > > +} IBVERBS_1.3;
> > >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OAiy6VLsECigG9dy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4TnJAAoJEORje4g2clinr9sP/jeyXhjkrCBkmTUeEPhsNtaN
gpTiGIRqw8ZdHUpM1JnPVYCOGPROV0Nqy9OM96pLNsbH/SIgwR1cMFHxCunXAKru
XM44HgSUpP7pYWLjs9bPdz2y3nQSHyO3T1zRhKpV/KsfQce2S64YNXuvLbjMJwXk
9uSzokxLfVOyGOLhoAnsM8sZ+NBE+o4+2rHQ7vZVJ+zmxS/EYY2LRW4p0NL0bTsm
rLmJc+xZIQm68gQqtOaQEV7P5rVeiRSFnNDrAs83DZLtG+uhlfUKmS8r04Kn4xyI
UlqjvrE+VGudguvLn0QZKgq2ekywGTpLGW+RclmXukeJZ6AOzR3loAku/5PUNjGH
AIKNrHb66UaQmvKgU1R02ajh5OQ6xLe9QnV2VWifYDnNOwYczpw/eYMHmhlQs0B7
hsXOOnDCsx9SO1qxvPoLRi9rKBfonUrV+kL1We2qcVTJQEUCC1PoSAH1bOcfd9G/
Ib6Jc76iyUw2sDvaek2cNOGLQqlW3RnZbfc0/bStiJpXhfSmJ2azNMIMS6j1oY8D
aWD1xx0pJA0WZ46cfmkj6b8fO60bPbK+xsoQkFPOv29/yN/gXgZCIMF1zIhcpeu+
4A0dD4S+TL09TIpjdvBXKuQhq5UgYqtekoVBxYVhfvPeLmySL7EIdnP8QxBKNB7t
QHpFqrItTkI9tZVMT4gB
=y8Kn
-----END PGP SIGNATURE-----

--OAiy6VLsECigG9dy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
