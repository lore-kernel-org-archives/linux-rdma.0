From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 1/5] RDMA/core: Provide getter and setter to
 access IB device name
Date: Thu, 20 Sep 2018 19:40:39 +0300
Message-ID: <20180920164039.GM3519@mtr-leonro.mtl.com>
References: <20180920112202.9181-1-leon@kernel.org>
 <20180920112202.9181-2-leon@kernel.org>
 <20180920151541.GC30219@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4LFBTxd4L5NLO6ly"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920151541.GC30219@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org


--4LFBTxd4L5NLO6ly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 20, 2018 at 09:15:41AM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 20, 2018 at 02:21:58PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Prepare IB device name field to rename operation by ensuring that all
> > accesses to it are protected with lock and users don't see part of name.
>
> Oh dear, no, that isn't going to work, there is too much stuff using
> dev_name.. Did you read the comment on device_rename??
>
> https://elixir.bootlin.com/linux/v4.19-rc4/source/drivers/base/core.c#L2715

Yes, I read, it was mentioned in the cover letter.

>
> > The protection is done with global device_lock because it is used in
> > allocation and deallocation phases. At this stage, this lock is not
> > busy and easily can be moved to be per-device, once it will be needed.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/core/device.c | 24 +++++++++++++++++++++++-
> >  include/rdma/ib_verbs.h          |  8 +++++++-
> >  2 files changed, 30 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index 5a680a88aa87..3270cde6d806 100644
> > +++ b/drivers/infiniband/core/device.c
> > @@ -170,6 +170,14 @@ static struct ib_device *__ib_device_get_by_name(const char *name)
> >  	return NULL;
> >  }
> >
> > +void ib_device_get_name(struct ib_device *ibdev, char *name)
> > +{
> > +	down_read(&lists_rwsem);
> > +	strlcpy(name, ibdev->name, IB_DEVICE_NAME_MAX);
> > +	up_read(&lists_rwsem);
> > +}
> > +EXPORT_SYMBOL(ib_device_get_name);
>
> I think we have to follow netdev and just rely on device_rename()
> being 'good enough'.
>
> Switch everything to use dev_name()/etc rather than try and do
> something like this so the responsibility is on the device core to
> keep this working, not us.
>
> Turns out I have a series for that for unrelated reasons..

And what should I do now with this knowledge?

>
> >  static int alloc_name(char *name)
> >  {
> >  	unsigned long *inuse;
> > @@ -202,6 +210,21 @@ static int alloc_name(char *name)
> >  	return 0;
> >  }
> >
> > +int ib_device_alloc_name(struct ib_device *ibdev, const char *pattern)
> > +{
> > +	int ret = 0;
> > +
> > +	mutex_lock(&device_mutex);
> > +	strlcpy(ibdev->name, pattern, IB_DEVICE_NAME_MAX);
> > +	if (strchr(ibdev->name, '%'))
> > +		ret = alloc_name(ibdev->name);
> > +
> > +	mutex_unlock(&device_mutex);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(ib_device_alloc_name);
>
> Can't call alloc_name() without also adding to the list, this will
> allow duplicates.

I planned to change it in the future by moving to different name scheme
with unique naming.

>
> Jason

--4LFBTxd4L5NLO6ly
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbo82HAAoJEORje4g2clinr98QAIGrGQCKj95PZxzPa497XFxU
KRrbTrB0YuH3w/DZlwYe8XWpqijnNxtY3sghPAW60sKhBxniPRoJXDDPTrP1Li0y
eTIIdGxTtIHQkP3f8AqVMARmset3qRGInQVRAyKJTI7p41YrQ/7FzerlAkmsL5eR
c62gqvmLc46p5auNI5NMppE3+r3tkZ3/nlQUcdf9xfYQbnvtCzHddvqfan9MwvTZ
VFgKgtOCcx5Hs8J1aFq7UVa71ociBJPzruvjam9HBMQDhnTlsBDYvkwI+wHZTCcp
ISODlykPw6TYhlvDO6ZD/5nhP2vjXBt0WskTp7khy+r1soetpTSS/KT5oZb3EivT
P7d7esC3Sjo3iG1yQVACzMLWQqU5zE8b4Cu+1nQBsNr2WGoUN3Iqm2Q/8Inee2E2
e4b9uv/bZ5OxrmX+w1qdq2bYuNNPzOcmRZwbLjyXq1r1GT6nk99pErQ9Hz93ggcX
oOmCL25ymLFpDct3B/osidtg0fBj2u0DSzMs+uawCesid6Zboqh0EgDPpXMAyuvf
Y8PSkvZtNRQqusRRf6jnfOmh11norhV6JiqI5mTrq2Jca9mkJdvn2SrWYPVUx5WW
xQKkj076Ib6ab3an4nNh51LpImI9lwKxYIX1yfQePnAzqkugm4tV+1bR5Z2RfPYS
XKjiEs14RYixfkxVUnGv
=Uhur
-----END PGP SIGNATURE-----

--4LFBTxd4L5NLO6ly--
