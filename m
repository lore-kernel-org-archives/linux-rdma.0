From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/core: export ib_get_cached_port_state
Date: Mon, 12 Dec 2016 14:31:05 +0100
Message-ID: <CAMGffEmu+UcC7uk86qu7sPawKaBOOe6Fj2ogTrvsdA72O-yokw@mail.gmail.com>
References: <CAMGffEnCU-8sodNH_i-KKPAhe3ekkt+Yd34wiUVqvXJ+ujSRwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11463ea0d3405e0543761e79
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffEnCU-8sodNH_i-KKPAhe3ekkt+Yd34wiUVqvXJ+ujSRwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a11463ea0d3405e0543761e79
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Add Mark in reply.

Hi, Mark,



On Mon, Dec 12, 2016 at 12:45 PM, Jinpu Wang
<jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> From 1cf770be635e987e31feed2f7c82b9f4f3bd316a Mon Sep 17 00:00:00 2001
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date: Mon, 12 Dec 2016 10:12:39 +0100
> Subject: [PATCH 2/4] IB/core: export ib_get_cached_port_state
>
> Export function for rdma_cm, patch will follow.
>
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c | 18 ++++++++++++++++++
>  include/rdma/ib_cache.h         | 13 +++++++++++++
>  2 files changed, 31 insertions(+)
>
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/ca=
che.c
> index 025db27..1b064cf 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -1025,6 +1025,24 @@ int ib_get_cached_lmc(struct ib_device *device,
>  }
>  EXPORT_SYMBOL(ib_get_cached_lmc);
>
> +int ib_get_cached_port_state(struct ib_device   *device,
> +                 u8                  port_num,
> +                 enum ib_port_state *port_state)
Q: Can you please fix the style (indentation)
A: format mangled by gmail, I attached the patch in attachment.

> +{
> +    unsigned long flags;
> +    int ret =3D 0;
> +
> +    if (port_num < rdma_start_port(device) || port_num > rdma_end_port(d=
evice))
> +        return -EINVAL;
> +
> +    read_lock_irqsave(&device->cache.lock, flags);
> +    *port_state =3D device->cache.port_state_cache[port_num -
> rdma_start_port(device)];
> +    read_unlock_irqrestore(&device->cache.lock, flags);
> +
> +    return ret;
> +}
> +EXPORT_SYMBOL(ib_get_cached_port_state);
> +
Q: Why do you need ret? just return 0.
A: We just need to keep the same style as ib_get_cached_lmc(), ret could be
reserved, indentation should be consistent if not.

>  static void ib_cache_update(struct ib_device *device,
>                  u8                port)
>  {
> diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
> index e30f19b..385ec88 100644
> --- a/include/rdma/ib_cache.h
> +++ b/include/rdma/ib_cache.h
> @@ -165,4 +165,17 @@ int ib_get_cached_lmc(struct ib_device *device,
>                u8                port_num,
>                u8                *lmc);
>
> +/**
> + * ib_get_cached_port_state - Returns a cached port state table entry
> + * @device: The device to query.
> + * @port_num: The port number of the device to query.
> + * @port_state: port_state for the specified port for that device.
> + *
> + * ib_get_cached_port_state() fetches the specified port_state table
> entry stored in
> + * the local software cache.
> + */
> +int ib_get_cached_port_state(struct ib_device *device,
> +                  u8                port_num,
> +                  enum ib_port_state *port_active);
> +
>  #endif /* _IB_CACHE_H */
> --
> 2.7.4
>
>
Thanks!
--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss

--001a11463ea0d3405e0543761e79
Content-Type: text/x-patch; charset=US-ASCII;
	name="0002-IB-core-export-ib_get_cached_port_state.patch"
Content-Disposition: attachment;
	filename="0002-IB-core-export-ib_get_cached_port_state.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwm498pm0

RnJvbSAxY2Y3NzBiZTYzNWU5ODdlMzFmZWVkMmY3YzgyYjlmNGYzYmQzMTZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogTW9uLCAxMiBEZWMgMjAxNiAxMDoxMjozOSArMDEwMApTdWJqZWN0OiBbUEFUQ0gg
Mi80XSBJQi9jb3JlOiBleHBvcnQgaWJfZ2V0X2NhY2hlZF9wb3J0X3N0YXRlCgpFeHBvcnQgZnVu
Y3Rpb24gZm9yIHJkbWFfY20sIHBhdGNoIHdpbGwgZm9sbG93LgoKU2lnbmVkLW9mZi1ieTogSmFj
ayBXYW5nIDxqaW5wdS53YW5nQHByb2ZpdGJyaWNrcy5jb20+ClJldmlld2VkLWJ5OiBNaWNoYWVs
IFdhbmcgPHl1bi53YW5nQHByb2ZpdGJyaWNrcy5jb20+Ci0tLQogZHJpdmVycy9pbmZpbmliYW5k
L2NvcmUvY2FjaGUuYyB8IDE4ICsrKysrKysrKysrKysrKysrKwogaW5jbHVkZS9yZG1hL2liX2Nh
Y2hlLmggICAgICAgICB8IDEzICsrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMzEgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NhY2hlLmMg
Yi9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jYWNoZS5jCmluZGV4IDAyNWRiMjcuLjFiMDY0Y2Yg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NhY2hlLmMKKysrIGIvZHJpdmVy
cy9pbmZpbmliYW5kL2NvcmUvY2FjaGUuYwpAQCAtMTAyNSw2ICsxMDI1LDI0IEBAIGludCBpYl9n
ZXRfY2FjaGVkX2xtYyhzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCiB9CiBFWFBPUlRfU1lNQk9M
KGliX2dldF9jYWNoZWRfbG1jKTsKIAoraW50IGliX2dldF9jYWNoZWRfcG9ydF9zdGF0ZShzdHJ1
Y3QgaWJfZGV2aWNlICAgKmRldmljZSwKKwkJCSAgICAgdTggICAgICAgICAgICAgICAgICBwb3J0
X251bSwKKwkJCSAgICAgZW51bSBpYl9wb3J0X3N0YXRlICpwb3J0X3N0YXRlKQoreworCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7CisJaW50IHJldCA9IDA7CisKKwlpZiAocG9ydF9udW0gPCByZG1hX3N0
YXJ0X3BvcnQoZGV2aWNlKSB8fCBwb3J0X251bSA+IHJkbWFfZW5kX3BvcnQoZGV2aWNlKSkKKwkJ
cmV0dXJuIC1FSU5WQUw7CisKKwlyZWFkX2xvY2tfaXJxc2F2ZSgmZGV2aWNlLT5jYWNoZS5sb2Nr
LCBmbGFncyk7CisJKnBvcnRfc3RhdGUgPSBkZXZpY2UtPmNhY2hlLnBvcnRfc3RhdGVfY2FjaGVb
cG9ydF9udW0gLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV07CisJcmVhZF91bmxvY2tfaXJxcmVz
dG9yZSgmZGV2aWNlLT5jYWNoZS5sb2NrLCBmbGFncyk7CisKKwlyZXR1cm4gcmV0OworfQorRVhQ
T1JUX1NZTUJPTChpYl9nZXRfY2FjaGVkX3BvcnRfc3RhdGUpOworCiBzdGF0aWMgdm9pZCBpYl9j
YWNoZV91cGRhdGUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLAogCQkJICAgIHU4ICAgICAgICAg
ICAgICAgIHBvcnQpCiB7CmRpZmYgLS1naXQgYS9pbmNsdWRlL3JkbWEvaWJfY2FjaGUuaCBiL2lu
Y2x1ZGUvcmRtYS9pYl9jYWNoZS5oCmluZGV4IGUzMGYxOWIuLjM4NWVjODggMTAwNjQ0Ci0tLSBh
L2luY2x1ZGUvcmRtYS9pYl9jYWNoZS5oCisrKyBiL2luY2x1ZGUvcmRtYS9pYl9jYWNoZS5oCkBA
IC0xNjUsNCArMTY1LDE3IEBAIGludCBpYl9nZXRfY2FjaGVkX2xtYyhzdHJ1Y3QgaWJfZGV2aWNl
ICpkZXZpY2UsCiAJCSAgICAgIHU4ICAgICAgICAgICAgICAgIHBvcnRfbnVtLAogCQkgICAgICB1
OCAgICAgICAgICAgICAgICAqbG1jKTsKIAorLyoqCisgKiBpYl9nZXRfY2FjaGVkX3BvcnRfc3Rh
dGUgLSBSZXR1cm5zIGEgY2FjaGVkIHBvcnQgc3RhdGUgdGFibGUgZW50cnkKKyAqIEBkZXZpY2U6
IFRoZSBkZXZpY2UgdG8gcXVlcnkuCisgKiBAcG9ydF9udW06IFRoZSBwb3J0IG51bWJlciBvZiB0
aGUgZGV2aWNlIHRvIHF1ZXJ5LgorICogQHBvcnRfc3RhdGU6IHBvcnRfc3RhdGUgZm9yIHRoZSBz
cGVjaWZpZWQgcG9ydCBmb3IgdGhhdCBkZXZpY2UuCisgKgorICogaWJfZ2V0X2NhY2hlZF9wb3J0
X3N0YXRlKCkgZmV0Y2hlcyB0aGUgc3BlY2lmaWVkIHBvcnRfc3RhdGUgdGFibGUgZW50cnkgc3Rv
cmVkIGluCisgKiB0aGUgbG9jYWwgc29mdHdhcmUgY2FjaGUuCisgKi8KK2ludCBpYl9nZXRfY2Fj
aGVkX3BvcnRfc3RhdGUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLAorCQkJICAgICAgdTggICAg
ICAgICAgICAgICAgcG9ydF9udW0sCisJCQkgICAgICBlbnVtIGliX3BvcnRfc3RhdGUgKnBvcnRf
YWN0aXZlKTsKKwogI2VuZGlmIC8qIF9JQl9DQUNIRV9IICovCi0tIAoyLjcuNAoK
--001a11463ea0d3405e0543761e79--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
