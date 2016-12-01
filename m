From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Versions of packages included in rdma-core
Date: Thu, 1 Dec 2016 13:24:13 +0200
Message-ID: <20161201112413.GE4497@leon.nu>
References: <20161201080430.jrcketnrljckdbix@paradies.suse.de>
 <20161201081826.GD4497@leon.nu>
 <20161201100308.7zg4x557as7ruwge@paradies.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161201100308.7zg4x557as7ruwge-TXhXIaCUHZEYitT5tn2FcQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Fent <sf-l3A5Bk7waGM@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2016 at 11:03:08AM +0100, Philipp Thomas wrote:
> Hi Leon,
>
> * Leon Romanovsky (leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) [20161201 09:18]:
>
> > We imported everything published in their respective git repositories.
> But as it looks there isn't a log entry that marks the import. This makes=
 it
> hard to compare what we have in SLES to rdma-core to determine whether we=
 do
> the switch for the next service pack or wait for the next major SLES
> version.
>
> > Did you try to use git log --follow relevant_file?
>
> I didn't know that. But that would mean I would have to compare the git l=
ogs
> of all imported packages to see where they star t to differ :( I had hoped
> for an easier way, oh well...

Yes, there is an easy path :)

=E2=9E=9C  rdma-core git:(master) git show 2172d3c6d73e
commit 2172d3c6d73e336743d6a08ca4e9c618595c2bc5
Merge: 0083ff6 27d8654 e8c50a2 6d6ace8 560afd8 94aaf19 0de1a98 9c4dc56
f8cc421 f7340fc ef7827c f2d901b dfa0d02 cfd7546 364b7da 663098b 2f00a5b
83d9ee5
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Tue Sep 20 11:42:56 2016 -0600

    Initial commit

    This was built from the original upstream repositories:
    ibacm https://github.com/ofiwg/ibacm.git  6b3303c6d88b40d11e86953e773e1=
4bc9e6d79c7
    iwpmd git://git.openfabrics.org/~tnikolova/libiwpm a42bdc977a832071404e=
af307b81e0e31f8a4e64
    libcxgb3 git://git.openfabrics.org/~swise/libcxgb3.git 12b68e5d8e2e0b89=
a73f90af6e8a06bb7a748271
    libcxgb4 git://git.openfabrics.org/~swise/libcxgb4.git fab9b66438ef19d6=
92d6ce6d7dd346043454696c
    libhfi1verbs https://github.com/01org/opa-libhfi1verbs.git c8df83205622=
a21d7062ac68cc8c4238953bba7d
    libi40iw git://git.openfabrics.org/~tnikolova/libi40iw/.git 9d35609f79d=
6a235e23182e9ceadf3605b2682da
    libibcm git://git.openfabrics.org/~shefty/libibcm.git b04920e8bfe0689a2=
fe67815321dcf646fd48a7e
    libibumad git://git.openfabrics.org/~halr/libibumad.git 0765c870a6ddc16=
a57b68d981a2ff108c178dc93
    libibverbs git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git =
3b3973377f0dbccb11323b86e267308052cc4458
    libipathverbs https://github.com/01org/libipathverbs.git 8291d485f3a554=
4b43974e7be88f3646f35ae07c
    libmlx4 git://git.openfabrics.org/~yishaih/libmlx4.git 8aee6a7d2104395f=
b967fb52564adbb2dc2b83c4
    libmlx5 git://git.openfabrics.org/~yishaih/libmlx5.git 0f2c49cfdb86b01a=
f5387f34ee20960b258998f8
    libmthca git://git.kernel.org/pub/scm/libs/infiniband/libmthca.git 6f4d=
d7451ddef120247e13fa6cb8e1df69c3ddf9
    libnes git://git.openfabrics.org/~tnikolova/libnes/.git 51f4aa8ced48a24=
1cfccb6e318cc58e44ab260bc
    libocrdma git://git.openfabrics.org/~emulex/libocrdma.git 41f6bbb3fe812=
9678c233da439d872b3fe9f75dc
    librdmacm https://github.com/ofiwg/librdmacm.git 37ae092e626d9cc58a888e=
edca44f21ccdd7632a
    librxe https://github.com/SoftRoCE/librxe-dev.git 227e3c49b6e423c066e1e=
1887fe30c8261f63cbd
    srp_daemon git://git.openfabrics.org/~bvanassche/srptools.git 4ce3074a1=
f94f93c9b629437e89312d919d323fc

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>


>
> Philipp
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYQAhdAAoJEORje4g2clinMD0P/1GxW1bUXe4Gvb55Kvw+SkdW
jqufPvDi3fDEYitEVI4EI9vYyFLSt206ihTLmzZ0RzU5rUdr/e35N+dzesPr1vx7
xktxeOaHAvhEghWNDtgJtSSvqiW+OIIp38Txg1l5ynj9i6KmYqmOZDG9S99it90d
BrsqJx4WhQpVupFt6bStHcvImxUjpnSF3Il7iKY/wgol5soM8H6q38/l78yjh3WC
wonApmLmxBmI1zJoRP0vqC4qYAxB/Dsz3943LVvBjO4pLTailRmnGBth37NIFBVt
LcjxPpmrRyaQOcb12M5Vbm7tjZh/cvdXGQ6IewJQ3TrCcypiJU5HMHywlJb1vTDY
tXG8bmXSG6warWRrMhMNg4+F8QuExU39Tz7eIZTA7rldnj0GonAlUMTln1q7cg9k
ZhhlHr5hK4f3YhyT+tU2Cut4jv8X7Km12GFDWHaX/MuSV7OgmOPENrk5CCgGRlss
8SFU5n6FGW0frpQ1smz5fbkWwlvj0aPcCg54Tmtj9iBuswooINbVMBpGMOtPoRTX
E7NBHnOq1ObPkZufC/xwm4dXEkUKCfkfTuBdsATaoWEGixFh2HVS4IzCPZ13DPS/
PPaqSc1P+sGBgkUybH3aq9M9l3x8mQnXqgIFaQrtukaR60VrjBrehG1a5lA9Q8U1
OvVVPFVmRDPLk6MQK6Y5
=qehr
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
