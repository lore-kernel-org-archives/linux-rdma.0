From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 1/1] infiniband/mm: convert put_page() to put_user_page*()
Date: Thu, 23 May 2019 10:56:56 -0700
Message-ID: <708b9fc4-9afd-345e-83f7-2ceae673a4fd@nvidia.com>
References: <20190523072537.31940-1-jhubbard@nvidia.com>
 <20190523072537.31940-2-jhubbard@nvidia.com>
 <20190523153133.GB5104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523153133.GB5104@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@mellanox.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 5/23/19 8:31 AM, Jerome Glisse wrote:
[...]
>=20
> Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20

Thanks for the review!

> Between i have a wishlist see below
[...]
>> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/um=
em.c
>> index e7ea819fcb11..673f0d240b3e 100644
>> --- a/drivers/infiniband/core/umem.c
>> +++ b/drivers/infiniband/core/umem.c
>> @@ -54,9 +54,10 @@ static void __ib_umem_release(struct ib_device *dev, =
struct ib_umem *umem, int d
>>  =20
>>   	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
>>   		page =3D sg_page_iter_page(&sg_iter);
>> -		if (!PageDirty(page) && umem->writable && dirty)
>> -			set_page_dirty_lock(page);
>> -		put_page(page);
>> +		if (umem->writable && dirty)
>> +			put_user_pages_dirty_lock(&page, 1);
>> +		else
>> +			put_user_page(page);
>=20
> Can we get a put_user_page_dirty(struct page 8*pages, bool dirty, npages)=
 ?
>=20
> It is a common pattern that we might have to conditionaly dirty the pages
> and i feel it would look cleaner if we could move the branch within the
> put_user_page*() function.
>=20

This sounds reasonable to me, do others have a preference on this? Last tim=
e
we discussed it, I recall there was interest in trying to handle the sg lis=
ts,
which was where a lot of focus was. I'm not sure if there was a preference =
one=20
way or the other, on adding more of these helpers.


thanks,
--=20
John Hubbard
NVIDIA
