From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: 4.5-rc iser issues
Date: Mon, 15 Feb 2016 00:20:58 +0800
Message-ID: <CACVXFVNAkf5+XFyf2JkcfeEPO2sv9bqHMR+N+=kKFzrtXpFEnA@mail.gmail.com>
References: <20160214074119.GA24558@infradead.org>
	<56C04294.3090701@dev.mellanox.co.il>
	<56C05000.1040001@dev.mellanox.co.il>
	<56C066AF.6050901@dev.mellanox.co.il>
	<56C088EA.1050901@dev.mellanox.co.il>
	<20160214152223.GA5323@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c05d8081cc312052bbd495e
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214152223.GA5323-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lin-SSI <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--94eb2c05d8081cc312052bbd495e
Content-Type: text/plain; charset=UTF-8

Hi Sagi,

On Sun, Feb 14, 2016 at 11:22 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Adding Ming to Cc.
>
> But I don't think simply not cloning the biovecs is the right thing
> to do in the end.  This must be something with the bvec iterators.

I agree with Christoph, and there might be issues somewhere.

> From the log:
> iser: sg[0] dma_addr:0x85FC06000 off:0x0 sz:0x200 dma_len:0x200
> iser: sg[1] dma_addr:0x860334000 off:0x0 sz:0x200 dma_len:0x200 <-- gap
> iser: sg[2] dma_addr:0x860335000 off:0x0 sz:0x200 dma_len:0x200 <-- gap

The above gap shouldn't have come since blk_bio_segment_split() splits
out one new bio if gap is detected.

Sort of the following code can be added in driver or prep_fn to check if
bvec of  the rq is correct:

rq_for_each_segment(bvec, sc->request, iter) {
     //check if there is gap between bvec
}

I don't know how to use iser, and looks everything works fine after
I setup virt boundary as 4095 for null_blk by the attachment
patch.

> Full quote for Ming:
>
> On Sun, Feb 14, 2016 at 04:02:18PM +0200, Sagi Grimberg wrote:
>>
>> >>I'm bisecting now, there are a couple of patches from Ming in
>> >>the area of the bio splitting code...
>> >>
>> >>CC'ing Ming, Linux-block and Linux-nvme as iser is identical to nvme
>> >>wrt the virtual boundary so I think nvme will break as well.

The bisected commit is merged to v4.3, and looks no such kind of
report from nvme.

>> >
>> >Bisection reveals that this one is the culprit:
>> >
>> >commit 52cc6eead9095e2faf2ec7afc013aa3af1f01ac5
>> >Author: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> >Date:   Thu Sep 17 09:58:38 2015 -0600
>> >
>> >     block: blk-merge: fast-clone bio when splitting rw bios
>> >
>> >     biovecs has become immutable since v3.13, so it isn't necessary
>> >     to allocate biovecs for the new cloned bios, then we can save
>> >     one extra biovecs allocation/copy, and the allocation is often
>> >     not fixed-length and a bit more expensive.
>> >
>> >     For example, if the 'max_sectors_kb' of null blk's queue is set
>> >     as 16(32 sectors) via sysfs just for making more splits, this patch
>> >     can increase throught about ~70% in the sequential read test over
>> >     null_blk(direct io, bs: 1M).
>> >
>> >     Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> >     Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >     Cc: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
>> >     Cc: Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>
>> >     Signed-off-by: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> >
>> >     This fixes a performance regression introduced by commit 54efd50bfd,
>> >     and allows us to take full advantage of the fact that we have
>> >immutable
>> >     bio_vecs. Hand applied, as it rejected violently with commit
>> >     5014c311baa2.
>> >
>> >     Signed-off-by: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
>> >--
>>
>> Looks like there is a problem with bio_clone_fast()
>>
>> This change makes the problem go away:
>> --
>> diff --git a/block/bio.c b/block/bio.c
>> index dbabd48..5e93733 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -1791,7 +1791,7 @@ struct bio *bio_split(struct bio *bio, int sectors,
>>          * Discards need a mutable bio_vec to accommodate the payload
>>          * required by the DSM TRIM and UNMAP commands.
>>          */
>> -       if (bio->bi_rw & REQ_DISCARD)
>> +       if (1 || bio->bi_rw & REQ_DISCARD)
>>                 split = bio_clone_bioset(bio, gfp, bs);
>>         else
>>                 split = bio_clone_fast(bio, gfp, bs);
>> --
>>
>> Any thoughts?

I don't think bio_clone_fast() is wrong, which use bvec table from
the original bio, and drivers are not allowed to change the table, and
should just call the standard iterator helpers to access bvec.

Also bio_for_each_segment_all() can't be used to iterate over one
cloned bio.

Thanks,

--94eb2c05d8081cc312052bbd495e
Content-Type: text/x-patch; charset=US-ASCII; name="null_blk_sg_virt_boundary.patch"
Content-Disposition: attachment; filename="null_blk_sg_virt_boundary.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ikmqfwr40

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbnVsbF9ibGsuYyBiL2RyaXZlcnMvYmxvY2svbnVs
bF9ibGsuYwppbmRleCA4YmExZTk3Li41MzI4ZjNjIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jsb2Nr
L251bGxfYmxrLmMKKysrIGIvZHJpdmVycy9ibG9jay9udWxsX2Jsay5jCkBAIC0xMCw2ICsxMCw4
IEBACiAjaW5jbHVkZSA8bGludXgvaHJ0aW1lci5oPgogI2luY2x1ZGUgPGxpbnV4L2xpZ2h0bnZt
Lmg+CiAKKyNkZWZpbmUgTUFYX1NHCTEyOAorCiBzdHJ1Y3QgbnVsbGJfY21kIHsKIAlzdHJ1Y3Qg
bGlzdF9oZWFkIGxpc3Q7CiAJc3RydWN0IGxsaXN0X25vZGUgbGxfbGlzdDsKQEAgLTE5LDYgKzIx
LDcgQEAgc3RydWN0IG51bGxiX2NtZCB7CiAJdW5zaWduZWQgaW50IHRhZzsKIAlzdHJ1Y3QgbnVs
bGJfcXVldWUgKm5xOwogCXN0cnVjdCBocnRpbWVyIHRpbWVyOworCXN0cnVjdCBzY2F0dGVybGlz
dCBzZ1tNQVhfU0ddOwogfTsKIAogc3RydWN0IG51bGxiX3F1ZXVlIHsKQEAgLTM1MSw2ICszNTQs
MjMgQEAgc3RhdGljIHZvaWQgbnVsbF9yZXF1ZXN0X2ZuKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpx
KQogCX0KIH0KIAorc3RhdGljIGludCBoYW5kbGVfc2coc3RydWN0IG51bGxiX2NtZCAqY21kKQor
eworCWludCBudW0sIGk7CisJc3RydWN0IHJlcXVlc3QgKnJxID0gY21kLT5ycTsKKworCW51bSA9
IGJsa19ycV9tYXBfc2cocnEtPnEsIHJxLCBjbWQtPnNnKTsKKwl0cmFjZV9wcmludGsoIiVzIGR1
bXAgc2cgZm9yICVwKCVkKVxuIiwgX19mdW5jX18sIHJxLCBycS0+dGFnKTsKKwlmb3IgKGkgPSAw
OyBpIDwgbnVtOyBpKyspIHsKKwkJc3RydWN0IHNjYXR0ZXJsaXN0ICpzZyA9ICZjbWQtPnNnW2ld
OworCQl0cmFjZV9wcmludGsoIlx0ICU0ZDogJXUgJXUgJWxsdVxuIiwKKwkJCSAgICAgaSwgc2ct
Pm9mZnNldCwgc2ctPmxlbmd0aCwKKwkJCSAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylzZy0+ZG1h
X2FkZHJlc3MpOworCX0KKworCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50IG51bGxfcXVldWVf
cnEoc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgsCiAJCQkgY29uc3Qgc3RydWN0IGJsa19tcV9x
dWV1ZV9kYXRhICpiZCkKIHsKQEAgLTM2NSw2ICszODUsOCBAQCBzdGF0aWMgaW50IG51bGxfcXVl
dWVfcnEoc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgsCiAKIAlibGtfbXFfc3RhcnRfcmVxdWVz
dChiZC0+cnEpOwogCisJaGFuZGxlX3NnKGNtZCk7CisKIAludWxsX2hhbmRsZV9jbWQoY21kKTsK
IAlyZXR1cm4gQkxLX01RX1JRX1FVRVVFX09LOwogfQpAQCAtNzA3LDYgKzcyOSw4IEBAIHN0YXRp
YyBpbnQgbnVsbF9hZGRfZGV2KHZvaWQpCiAJcXVldWVfZmxhZ19zZXRfdW5sb2NrZWQoUVVFVUVf
RkxBR19OT05ST1QsIG51bGxiLT5xKTsKIAlxdWV1ZV9mbGFnX2NsZWFyX3VubG9ja2VkKFFVRVVF
X0ZMQUdfQUREX1JBTkRPTSwgbnVsbGItPnEpOwogCisJYmxrX3F1ZXVlX3ZpcnRfYm91bmRhcnko
bnVsbGItPnEsICgxVUwgPDwgMTIpIC0gMSk7CisJYmxrX3F1ZXVlX21heF9zZWdtZW50cyhudWxs
Yi0+cSwgTUFYX1NHKTsKIAogCW11dGV4X2xvY2soJmxvY2spOwogCWxpc3RfYWRkX3RhaWwoJm51
bGxiLT5saXN0LCAmbnVsbGJfbGlzdCk7Cg==
--94eb2c05d8081cc312052bbd495e--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
