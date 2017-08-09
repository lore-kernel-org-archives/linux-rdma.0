From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 12/27] IB/core: Change port_attr.sm_lid from 16
 to 32 bits
Date: Wed, 9 Aug 2017 09:57:30 +0300
Message-ID: <20170809065730.GC1423@mtr-leonro.local>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
 <20170804205320.17853.77236.stgit@scvm10.sc.intel.com>
 <20170806081857.GC3636@mtr-leonro.local>
 <20170806082217.GE3636@mtr-leonro.local>
 <20170808144146.GF28851@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67CFAF96@CRSMSX101.amr.corp.intel.com>
 <018c6e70-78d5-51ec-993f-35be575a6da1@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <018c6e70-78d5-51ec-993f-35be575a6da1-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 08, 2017 at 09:49:17AM -0700, Don Hiatt wrote:
>
>
> On 8/8/2017 9:35 AM, Weiny, Ira wrote:
> > > On Sun, Aug 06, 2017 at 11:22:17AM +0300, Leon Romanovsky wrote:
> > > > On Sun, Aug 06, 2017 at 11:18:57AM +0300, Leon Romanovsky wrote:
> > > > > On Fri, Aug 04, 2017 at 01:53:21PM -0700, Dennis Dalessandro wrote:
> > > > > > From: Dasaratharaman Chandramouli
> > > > > > <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > >
> > > > > > sm_lid field in struct ib_port_attr is increased to 32 bits. This
> > > > > > enables core components to use larger LIDs if needed.
> > > > > > The user ABI is unchanged and return 16 bit values when queried.
> > > > > >
> > > > > > Signed-off-by: Dasaratharaman Chandramouli
> > > > > > <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > ---
> > > > > >   drivers/infiniband/core/uverbs_cmd.c |    8 +++++---
> > > > > >   include/rdma/ib_verbs.h              |    2 +-
> > > > > >   2 files changed, 6 insertions(+), 4 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > > > > > b/drivers/infiniband/core/uverbs_cmd.c
> > > > > > index 7ef74b0..38dce45 100644
> > > > > > --- a/drivers/infiniband/core/uverbs_cmd.c
> > > > > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > > > > @@ -275,11 +275,13 @@ ssize_t ib_uverbs_query_port(struct
> > > ib_uverbs_file *file,
> > > > > >   	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
> > > > > >   	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
> > > > > >   	resp.pkey_tbl_len    = attr.pkey_tbl_len;
> > > > > > -	resp.sm_lid 	     = attr.sm_lid;
> > > > > > -	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
> > > > > > +	if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
> > > > > >   		resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
> > > > > > -	else
> > > > > > +		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
> > > > > > +	} else {
> > > > > >   		resp.lid     = (u16)attr.lid;
> > > > > > +		resp.sm_lid  = (u16)attr.sm_lid;
> > > > > I see that lid is already has casting from u32 to u16 and now it is sm_lid.
> > > > > Do we have more elegant way to achieve that? And comment for future
> > > > > developers can be good too.
> > > > I see now, you changed lid in patch 11. The same comment there.
> > > To be clear on that point: NAK on *current* implementation.
> > >
> > > At least, it should be done in separate function, with comment explains why
> > > are you doing and why it is safe to cast from higher value to lower value and
> > > proper checks that you are not loosing information when you are casting.
> > >
> > A comment is reasonable.  However, I'm not sure a separate function is needed.  With the current interface there is no way to pass all the information through.
> >
> > Software which requires the use of these values will need to know to get them from other sources (OPA MAD queries for the SM LID for example.)
> >
> > Ira
> >
> Hi Leon,
>
> I had already created a function to do the cast in the 'IB/core: Change
> wc.slid from 16 to 32 bits' patch
> but I did not apply it here. Sorry about that.  My plan is to rename the
> functions to ib_lid_{spu16,be16}
> and introduce them in this patch with a comment in the git log that these
> functions exist. I will also add
> a comment stating why we aren't losing any information.

These functions should be introduced before "casting patches".

Thanks

>
> Thank you.
>
> don
>

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmKslkACgkQ5GN7iDZy
WKcN1RAArIp2023etmhIiXJez+6DdaVM63UKvivm1LrrmuyPGFF2b3eVcYTW3ftr
zDkkK7pmHSdVXJkqlOoWoZ1sHiq+zwId3Qhh3tefv3Vp1T+ZBKPeX3FNluoKBX3D
jaI6QJcLcY1bdJh0y2/x/J49TR09lHkwI8QqQyHkFNmKPyb3GXAez3Ylz6hFcvRG
ATBBmhHhziyUBVPMsVVBKOXkLwDvnh+e7b9CBmEf7IgHhk9vI+9kH1Us6ctnVhgn
GmG7JJQjSztdiidUt4aBVjfIlpB1zhVXFKhecWmFB01G+9S+ue7ZHJZ9FwxTGsEw
j4i575TYK10N/9H6GkfpfP6227Rm+0NAYjLMF6rBaEbHwup7LzMkELbEHk7oqV1B
mx85Z7dqt7P1A1Y+TfObElSXWqbb8avz68OoVeLdvugeOVV+2RfDwvabEm3ir67t
MtKghMartrQLGZ0hnZcz6/fEFKDJBvghWF+Mbb2mnfJdJZJeoDMUi4gwJtqZLMbQ
n8xb4KxhuAmZDuTuHShMeC7P8b/syQtjHIlAHTj4fK7lsdcJZJnMXqJrM08wiJnc
mABFstjJICburRACSCkYMaPDq8RrLikm5LHQ1x6eqYGj0xqUmJM438V3Amep4jTL
pG3HCZGvcWGFUyTSprd93kDYeA3RLoemMTjTRbPWTOaSutqavfQ=
=XM/t
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
