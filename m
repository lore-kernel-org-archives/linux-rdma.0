From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Wed, 1 Aug 2018 17:27:20 +0300
Message-ID: <f1442839-ff32-ab80-9eab-6923456fe272@mellanox.com>
References: <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
 <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com>
 <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com>
 <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com>
 <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me>
 <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com>
 <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com>
 <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com>
 <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com>
 <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com>
 <20180723164910.GS31540@mellanox.com>
 <c079b7b4-bff8-8ffe-0be5-e470c86479b4@mellanox.com>
 <b0f6a58a-0078-05a2-a7f9-946b2ff21846@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------317FF16D93EECD44A7798BFA"
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <b0f6a58a-0078-05a2-a7f9-946b2ff21846@grimberg.me>
Content-Language: he
Sender: netdev-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Steve Wise <swise@opengridcomputing.com>, 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--------------317FF16D93EECD44A7798BFA
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit



On 8/1/2018 8:12 AM, Sagi Grimberg wrote:
> Hi Max,

Hi,

> 
>> Yes, since nvmf is the only user of this function.
>> Still waiting for comments on the suggested patch :)
>>
> 
> Sorry for the late response (but I'm on vacation so I have
> an excuse ;))

NP :) currently the code works..

> 
> I'm thinking that we should avoid trying to find an assignment
> when stuff like irqbalance daemon is running and changing
> the affinitization.

but this is exactly what Steve complained and Leon try to fix (and break 
the connection establishment).
If this is the case and we all agree then we're good without Leon's 
patch and without our suggestions.

> 
> This extension was made to apply optimal affinity assignment
> when the device irq affinity is lined up in a vector per
> core.
> 
> I'm thinking that when we identify this is not the case, we immediately
> fallback to the default mapping.
> 
> 1. when we get a mask, if its weight != 1, we fallback.
> 2. if a queue was left unmapped, we fallback.
> 
> Maybe something like the following:

did you test it ? I think it will not work since you need to map all the 
queues and all the CPUs.

> -- 
> diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
> index 996167f1de18..1ada6211c55e 100644
> --- a/block/blk-mq-rdma.c
> +++ b/block/blk-mq-rdma.c
> @@ -35,17 +35,26 @@ int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
>          const struct cpumask *mask;
>          unsigned int queue, cpu;
> 
> +       /* reset all CPUs mapping */
> +       for_each_possible_cpu(cpu)
> +               set->mq_map[cpu] = UINT_MAX;
> +
>          for (queue = 0; queue < set->nr_hw_queues; queue++) {
>                  mask = ib_get_vector_affinity(dev, first_vec + queue);
>                  if (!mask)
>                          goto fallback;
> 
> -               for_each_cpu(cpu, mask)
> -                       set->mq_map[cpu] = queue;
> +               if (cpumask_weight(mask) != 1)
> +                       goto fallback;
> +
> +               cpu = cpumask_first(mask);
> +               if (set->mq_map[cpu] != UINT_MAX)
> +                       goto fallback;
> +
> +               set->mq_map[cpu] = queue;
>          }
> 
>          return 0;
> -
>   fallback:
>          return blk_mq_map_queues(set);
>   }
> -- 

see attached another algorithem that can improve the mapping (although 
it's not a short one)...

it will try to map according to affinity mask, and also in case the mask 
weight > 1 it will try to be better than the naive mapping I suggest in 
the previous email.


--------------317FF16D93EECD44A7798BFA
Content-Type: text/plain; charset="UTF-8";
	name="0001-blk-mq-fix-RDMA-queue-cpu-mappings-assignments-for-m.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0="0001-blk-mq-fix-RDMA-queue-cpu-mappings-assignments-for-m.pa";
	filename*1="tch"

RnJvbSAwMDdkNzczYWY3YjY1YTFmMWNhNTQzZjAzMWNhNThiM2FmYTViN2Q5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXggR3VydG92b3kgPG1heGdAbWVsbGFub3guY29t
PgpEYXRlOiBUaHUsIDE5IEp1bCAyMDE4IDEyOjQyOjAwICswMDAwClN1YmplY3Q6IFtQQVRD
SCAxLzFdIGJsay1tcTogZml4IFJETUEgcXVldWUvY3B1IG1hcHBpbmdzIGFzc2lnbm1lbnRz
IGZvciBtcQoKU2lnbmVkLW9mZi1ieTogTWF4IEd1cnRvdm95IDxtYXhnQG1lbGxhbm94LmNv
bT4KU2lnbmVkLW9mZi1ieTogSXNyYWVsIFJ1a3NoaW4gPGlzcmFlbHJAbWVsbGFub3guY29t
PgotLS0KIGJsb2NrL2Jsay1tcS1jcHVtYXAuYyAgfCA0MSArKysrKysrKysrKysrKy0tLS0t
LS0tLS0KIGJsb2NrL2Jsay1tcS1yZG1hLmMgICAgfCA4NCArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQogaW5jbHVkZS9saW51eC9ibGstbXEu
aCB8ICAxICsKIDMgZmlsZXMgY2hhbmdlZCwgMTAzIGluc2VydGlvbnMoKyksIDIzIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1tcS1jcHVtYXAuYyBiL2Jsb2NrL2Js
ay1tcS1jcHVtYXAuYwppbmRleCAzZWIxNjlmLi4wMmI4ODhmIDEwMDY0NAotLS0gYS9ibG9j
ay9ibGstbXEtY3B1bWFwLmMKKysrIGIvYmxvY2svYmxrLW1xLWNwdW1hcC5jCkBAIC0zMCwy
OSArMzAsMzYgQEAgc3RhdGljIGludCBnZXRfZmlyc3Rfc2libGluZyh1bnNpZ25lZCBpbnQg
Y3B1KQogCXJldHVybiBjcHU7CiB9CiAKLWludCBibGtfbXFfbWFwX3F1ZXVlcyhzdHJ1Y3Qg
YmxrX21xX3RhZ19zZXQgKnNldCkKK3ZvaWQgYmxrX21xX21hcF9xdWV1ZV90b19jcHUoc3Ry
dWN0IGJsa19tcV90YWdfc2V0ICpzZXQsIHVuc2lnbmVkIGludCBjcHUpCiB7CiAJdW5zaWdu
ZWQgaW50ICptYXAgPSBzZXQtPm1xX21hcDsKIAl1bnNpZ25lZCBpbnQgbnJfcXVldWVzID0g
c2V0LT5ucl9od19xdWV1ZXM7Ci0JdW5zaWduZWQgaW50IGNwdSwgZmlyc3Rfc2libGluZzsK
Kwl1bnNpZ25lZCBpbnQgZmlyc3Rfc2libGluZzsKIAotCWZvcl9lYWNoX3Bvc3NpYmxlX2Nw
dShjcHUpIHsKLQkJLyoKLQkJICogRmlyc3QgZG8gc2VxdWVudGlhbCBtYXBwaW5nIGJldHdl
ZW4gQ1BVcyBhbmQgcXVldWVzLgotCQkgKiBJbiBjYXNlIHdlIHN0aWxsIGhhdmUgQ1BVcyB0
byBtYXAsIGFuZCB3ZSBoYXZlIHNvbWUgbnVtYmVyIG9mCi0JCSAqIHRocmVhZHMgcGVyIGNv
cmVzIHRoZW4gbWFwIHNpYmxpbmcgdGhyZWFkcyB0byB0aGUgc2FtZSBxdWV1ZSBmb3IKLQkJ
ICogcGVyZm9ybWFjZSBvcHRpbWl6YXRpb25zLgotCQkgKi8KLQkJaWYgKGNwdSA8IG5yX3F1
ZXVlcykgeworCS8qCisJICogRmlyc3QgZG8gc2VxdWVudGlhbCBtYXBwaW5nIGJldHdlZW4g
Q1BVcyBhbmQgcXVldWVzLgorCSAqIEluIGNhc2Ugd2Ugc3RpbGwgaGF2ZSBDUFVzIHRvIG1h
cCwgYW5kIHdlIGhhdmUgc29tZSBudW1iZXIgb2YKKwkgKiB0aHJlYWRzIHBlciBjb3JlcyB0
aGVuIG1hcCBzaWJsaW5nIHRocmVhZHMgdG8gdGhlIHNhbWUgcXVldWUgZm9yCisJICogcGVy
Zm9ybWFjZSBvcHRpbWl6YXRpb25zLgorCSAqLworCWlmIChjcHUgPCBucl9xdWV1ZXMpIHsK
KwkJbWFwW2NwdV0gPSBjcHVfdG9fcXVldWVfaW5kZXgobnJfcXVldWVzLCBjcHUpOworCX0g
ZWxzZSB7CisJCWZpcnN0X3NpYmxpbmcgPSBnZXRfZmlyc3Rfc2libGluZyhjcHUpOworCQlp
ZiAoZmlyc3Rfc2libGluZyA9PSBjcHUpCiAJCQltYXBbY3B1XSA9IGNwdV90b19xdWV1ZV9p
bmRleChucl9xdWV1ZXMsIGNwdSk7Ci0JCX0gZWxzZSB7Ci0JCQlmaXJzdF9zaWJsaW5nID0g
Z2V0X2ZpcnN0X3NpYmxpbmcoY3B1KTsKLQkJCWlmIChmaXJzdF9zaWJsaW5nID09IGNwdSkK
LQkJCQltYXBbY3B1XSA9IGNwdV90b19xdWV1ZV9pbmRleChucl9xdWV1ZXMsIGNwdSk7Ci0J
CQllbHNlCi0JCQkJbWFwW2NwdV0gPSBtYXBbZmlyc3Rfc2libGluZ107Ci0JCX0KKwkJZWxz
ZQorCQkJbWFwW2NwdV0gPSBtYXBbZmlyc3Rfc2libGluZ107CiAJfQorfQorRVhQT1JUX1NZ
TUJPTF9HUEwoYmxrX21xX21hcF9xdWV1ZV90b19jcHUpOworCitpbnQgYmxrX21xX21hcF9x
dWV1ZXMoc3RydWN0IGJsa19tcV90YWdfc2V0ICpzZXQpCit7CisJdW5zaWduZWQgaW50IGNw
dTsKKworCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpCisJCWJsa19tcV9tYXBfcXVldWVf
dG9fY3B1KHNldCwgY3B1KTsKIAogCXJldHVybiAwOwogfQpkaWZmIC0tZ2l0IGEvYmxvY2sv
YmxrLW1xLXJkbWEuYyBiL2Jsb2NrL2Jsay1tcS1yZG1hLmMKaW5kZXggOTk2MTY3Zi4uNjIx
ZDVmMCAxMDA2NDQKLS0tIGEvYmxvY2svYmxrLW1xLXJkbWEuYworKysgYi9ibG9jay9ibGst
bXEtcmRtYS5jCkBAIC0xNCw2ICsxNCwzMyBAQAogI2luY2x1ZGUgPGxpbnV4L2Jsay1tcS1y
ZG1hLmg+CiAjaW5jbHVkZSA8cmRtYS9pYl92ZXJicy5oPgogCitzdGF0aWMgaW50IGJsa19t
cV9yZG1hX21hcF9xdWV1ZXNfYnlfYWZmaW5pdHkoc3RydWN0IGJsa19tcV90YWdfc2V0ICpz
ZXQsCisJCXN0cnVjdCBpYl9kZXZpY2UgKmRldiwgaW50IGZpcnN0X3ZlYywgaW50IG1heF9t
YXBwaW5nKQoreworCWNvbnN0IHN0cnVjdCBjcHVtYXNrICptYXNrOworCXVuc2lnbmVkIGlu
dCBxdWV1ZSwgY3B1OworCWludCBudW1fb2ZfbWFwcGluZyA9IDA7CisKKwlmb3IgKHF1ZXVl
ID0gMDsgcXVldWUgPCBzZXQtPm5yX2h3X3F1ZXVlczsgcXVldWUrKykgeworCQlpZiAobnVt
X29mX21hcHBpbmcgPT0gbWF4X21hcHBpbmcpCisJCQlyZXR1cm4gbnVtX29mX21hcHBpbmc7
CisKKwkJbWFzayA9IGliX2dldF92ZWN0b3JfYWZmaW5pdHkoZGV2LCBmaXJzdF92ZWMgKyBx
dWV1ZSk7CisJCWlmICghbWFzaykKKwkJCXJldHVybiAtMTsKKworCQlmb3JfZWFjaF9jcHUo
Y3B1LCBtYXNrKSB7CisJCQlpZiAoc2V0LT5tcV9tYXBbY3B1XSA9PSBVSU5UX01BWCkgewor
CQkJCXNldC0+bXFfbWFwW2NwdV0gPSBxdWV1ZTsKKwkJCQludW1fb2ZfbWFwcGluZysrOwor
CQkJCS8qIEVhY2ggcXVldWUgbWFwcGVkIHRvIDEgY3B1ICovCisJCQkJYnJlYWs7CisJCQl9
CisJCX0KKwl9CisJcmV0dXJuIG51bV9vZl9tYXBwaW5nOworfQorCiAvKioKICAqIGJsa19t
cV9yZG1hX21hcF9xdWV1ZXMgLSBwcm92aWRlIGEgZGVmYXVsdCBxdWV1ZSBtYXBwaW5nIGZv
ciByZG1hIGRldmljZQogICogQHNldDoJdGFnc2V0IHRvIHByb3ZpZGUgdGhlIG1hcHBpbmcg
Zm9yCkBAIC0zMiwxOCArNTksNjMgQEAKIGludCBibGtfbXFfcmRtYV9tYXBfcXVldWVzKHN0
cnVjdCBibGtfbXFfdGFnX3NldCAqc2V0LAogCQlzdHJ1Y3QgaWJfZGV2aWNlICpkZXYsIGlu
dCBmaXJzdF92ZWMpCiB7Ci0JY29uc3Qgc3RydWN0IGNwdW1hc2sgKm1hc2s7CiAJdW5zaWdu
ZWQgaW50IHF1ZXVlLCBjcHU7CisJYm9vbCBtYXBwZWQ7CisJaW50IHJlbWFpbmluZ19jcHVz
ID0gbnVtX3Bvc3NpYmxlX2NwdXMoKTsKKwlpbnQgdW5tYXBwZWRfcXVldWVzID0gc2V0LT5u
cl9od19xdWV1ZXM7CisJaW50IHJldDsKIAotCWZvciAocXVldWUgPSAwOyBxdWV1ZSA8IHNl
dC0+bnJfaHdfcXVldWVzOyBxdWV1ZSsrKSB7Ci0JCW1hc2sgPSBpYl9nZXRfdmVjdG9yX2Fm
ZmluaXR5KGRldiwgZmlyc3RfdmVjICsgcXVldWUpOwotCQlpZiAoIW1hc2spCisJLyogcmVz
ZXQgYWxsIENQVXMgbWFwcGluZyAqLworCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpCisJ
CXNldC0+bXFfbWFwW2NwdV0gPSBVSU5UX01BWDsKKworCS8qIFRyeSB0byBtYXAgdGhlIHF1
ZXVlcyBhY2NvcmRpbmcgdG8gYWZmaW5pdHkgKi8KKwlyZXQgPSBibGtfbXFfcmRtYV9tYXBf
cXVldWVzX2J5X2FmZmluaXR5KHNldCwgZGV2LCBmaXJzdF92ZWMsCisJCQkJCQkgcmVtYWlu
aW5nX2NwdXMpOworCWlmIChyZXQgPT0gLTEpCisJCWdvdG8gZmFsbGJhY2s7CisJcmVtYWlu
aW5nX2NwdXMgLT0gcmV0OworCXVubWFwcGVkX3F1ZXVlcyAtPSByZXQ7CisKKwkvKiBNYXAg
cXVldWVzIHdpdGggbW9yZSB0aGFuIG9uZSBjcHUgYWNjb3JkaW5nIHRvIGFmZmluaXR5ICov
CisJd2hpbGUgKHJlbWFpbmluZ19jcHVzID4gdW5tYXBwZWRfcXVldWVzKSB7CisJCXJldCA9
IGJsa19tcV9yZG1hX21hcF9xdWV1ZXNfYnlfYWZmaW5pdHkoc2V0LCBkZXYsIGZpcnN0X3Zl
YywKKwkJCQkJcmVtYWluaW5nX2NwdXMgLSB1bm1hcHBlZF9xdWV1ZXMpOworCQlpZiAocmV0
ID09IC0xKQogCQkJZ290byBmYWxsYmFjazsKKwkJaWYgKCFyZXQpCisJCQlicmVhazsKKwkJ
cmVtYWluaW5nX2NwdXMgLT0gcmV0OworCX0KIAotCQlmb3JfZWFjaF9jcHUoY3B1LCBtYXNr
KQotCQkJc2V0LT5tcV9tYXBbY3B1XSA9IHF1ZXVlOworCS8qIE1hcCB0aGUgdW5tYXBwZWQg
cXVldWVzIGluIGEgbmFpdmUgd2F5ICovCisJZm9yIChxdWV1ZSA9IDA7IHF1ZXVlIDwgc2V0
LT5ucl9od19xdWV1ZXM7IHF1ZXVlKyspIHsKKwkJbWFwcGVkID0gZmFsc2U7CisJCWZvcl9l
YWNoX3Bvc3NpYmxlX2NwdShjcHUpIHsKKwkJCWlmIChzZXQtPm1xX21hcFtjcHVdID09IHF1
ZXVlKSB7CisJCQkJbWFwcGVkID0gdHJ1ZTsKKwkJCQlicmVhazsKKwkJCX0KKwkJfQorCQlp
ZiAoIW1hcHBlZCkgeworCQkJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgeworCQkJCWlm
IChzZXQtPm1xX21hcFtjcHVdID09IFVJTlRfTUFYKSB7CisJCQkJCXNldC0+bXFfbWFwW2Nw
dV0gPSBxdWV1ZTsKKwkJCQkJbWFwcGVkID0gdHJ1ZTsKKwkJCQkJYnJlYWs7CisJCQkJfQor
CQkJfQorCQl9CisJCS8qIFRoaXMgY2FzZSBzaG91bGQgbmV2ZXIgaGFwcGVuICovCisJCWlm
IChXQVJOX09OX09OQ0UoIW1hcHBlZCkpCisJCQlnb3RvIGZhbGxiYWNrOwogCX0KIAorCS8q
IHNldCBhbGwgdGhlIHJlc3Qgb2YgdGhlIENQVXMgKi8KKwlmb3JfZWFjaF9wb3NzaWJsZV9j
cHUoY3B1KQorCQlpZiAoc2V0LT5tcV9tYXBbY3B1XSA9PSBVSU5UX01BWCkKKwkJCWJsa19t
cV9tYXBfcXVldWVfdG9fY3B1KHNldCwgY3B1KTsKKwogCXJldHVybiAwOwogCiBmYWxsYmFj
azoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmxrLW1xLmggYi9pbmNsdWRlL2xpbnV4
L2Jsay1tcS5oCmluZGV4IGUzMTQ3ZWIuLmQ2Y2QxMTQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bGludXgvYmxrLW1xLmgKKysrIGIvaW5jbHVkZS9saW51eC9ibGstbXEuaApAQCAtMjgyLDYg
KzI4Miw3IEBAIHZvaWQgYmxrX21xX3RhZ3NldF9idXN5X2l0ZXIoc3RydWN0IGJsa19tcV90
YWdfc2V0ICp0YWdzZXQsCiBpbnQgYmxrX21xX2ZyZWV6ZV9xdWV1ZV93YWl0X3RpbWVvdXQo
c3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCiAJCQkJICAgICB1bnNpZ25lZCBsb25nIHRpbWVv
dXQpOwogCit2b2lkIGJsa19tcV9tYXBfcXVldWVfdG9fY3B1KHN0cnVjdCBibGtfbXFfdGFn
X3NldCAqc2V0LCB1bnNpZ25lZCBpbnQgY3B1KTsKIGludCBibGtfbXFfbWFwX3F1ZXVlcyhz
dHJ1Y3QgYmxrX21xX3RhZ19zZXQgKnNldCk7CiB2b2lkIGJsa19tcV91cGRhdGVfbnJfaHdf
cXVldWVzKHN0cnVjdCBibGtfbXFfdGFnX3NldCAqc2V0LCBpbnQgbnJfaHdfcXVldWVzKTsK
IAotLSAKMS44LjMuMQoK
--------------317FF16D93EECD44A7798BFA--
