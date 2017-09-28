From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH for-next 8/9] RDMA/hns: Remove unused struct members in
 hns-abi.h
Date: Thu, 28 Sep 2017 16:04:37 +0300
Message-ID: <20170928130437.GV2297@mtr-leonro.local>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-9-git-send-email-xavier.huwei@huawei.com>
 <20170928090203.GS2297@mtr-leonro.local>
 <59CCE378.6070209@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SSJ6yXlPvEk0CmSI"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59CCE378.6070209@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org


--SSJ6yXlPvEk0CmSI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 07:56:40PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2017/9/28 17:02, Leon Romanovsky wrote:
> > On Thu, Sep 28, 2017 at 12:57:33PM +0800, Wei Hu (Xavier) wrote:
> > > From: Lijun Ou <oulijun@huawei.com>
> > >
> > > This patch mainly deletes some unused struct members for
> > > hns_roce_ib_create_qp in order to match libhns, because
> > > the num of struct members of hns_roce_ib_create_qp must
> > > be the same with hns_roce_create_qp in libhns.
> > >
> > > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > > Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
> > > Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
> > > ---
> > >   include/uapi/rdma/hns-abi.h | 2 --
> > >   1 file changed, 2 deletions(-)
> > >
> > > diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
> > > index 5d74019..79251b6 100644
> > > --- a/include/uapi/rdma/hns-abi.h
> > > +++ b/include/uapi/rdma/hns-abi.h
> > > @@ -41,10 +41,8 @@ struct hns_roce_ib_create_cq {
> > >
> > >   struct hns_roce_ib_create_qp {
> > >   	__u64	buf_addr;
> > > -	__u64   db_addr;
> > >   	__u8    log_sq_bb_count;
> > >   	__u8    log_sq_stride;
> > > -	__u8    sq_no_prefetch;
> > >   	__u8    reserved[5];
> > >   };
> > It is classical UAPI breakage which kernel tries to avoid.
> >
> > In RDMA, we do allow rename of fields from reserved to something, but
> > don't allow binary layout change.
> >
> > NAK to this change.
> >
> > Thanks
> Hi, Leon
>     Now there is an inconsistency between hns_roce_ib_create_qp in kernel
> driver and hns_roce_create_qp  in libhns as below:
>
> struct hns_roce_create_qp {
>     struct ibv_create_qp        ibv_cmd;
>     __u64                buf_addr;
>     __u8                log_sq_bb_count;
>     __u8                log_sq_stride;
>     __u8                reserved[5];
> };
>     It is better to modify hns_roce_create_qp in libhns, right?

Yes, it can work, because it is user space problem, where you used wrong
structure.

Thanks

>     Thanks
>
>     Regards
> Wei Hu
> > > --
> > > 1.9.1
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SSJ6yXlPvEk0CmSI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnM82QACgkQ5GN7iDZy
WKf2ZRAArocJRpfivWtqiQuv2KniDawmoJqbK3yDNovQHgQE2pkIThEA7lkMM33n
4hnMU5kZzDPfHlUrWhA3Hh4fHMlulK7aAulM1/mDyGa2mnTGIVPYFjB1/Q8VLn3p
k8t/gVPz3uL+acQzvaPe5JlNm0bp1d0Y7Kx5OtgDXLJIQqY1qgNe/Ei+xtSqK0SR
U5RgrXKtiV+SdUyrgOeA195CiT7nZuw/kPxm1pWoP1wAp/6xTcNzwQsQjgAD1Xr+
3clhjHRsKeS6iid04VFK/qnaO40e/DyZOnu6IAwsJo/YpdkaZUhvl+1105dvnz+O
YGJtsQc5NKCPcDOcjN31FWyPf3OyJFU2tdXoj3TQTGEp7rPORirNB94pJsMRKajJ
vLj3OUfd1KrrE+AcmtWa0Zhx743Ggx50YbPN+zwkU+3kUnOMnqT8Bqmxmm7tfGGu
c14JsgdWto2aYf8FnVS4SaLPJ6XcbmP2/E+BaZJrSMQN7O2yAQbFwFvYHAYBlUFN
8oPLdKDRNE1+13gYDTnGkgiC8/p2n3SN4EwRbCwnKdNpaySff5rMdN7Ljodw9Lsh
JM1E4cKW/R+9mRkUdlSScBka/8zUkwFbfHYdOti3E0NS0jYa0TU162rX0LaDecny
gk8lHrre1aI1EgUIK8ZoHC5equCYlGP5SDl3DACqNls7SF82qBA=
=/jdG
-----END PGP SIGNATURE-----

--SSJ6yXlPvEk0CmSI--
