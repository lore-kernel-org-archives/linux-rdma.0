From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] Add exponential backoff + random delay to MADs when
 retrying after timeout.
Date: Tue, 2 Nov 2010 16:58:13 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DEB@MNEXMB1.qlogic.org>
 <4CC976CC.1080009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5MNEXMB1qlogic_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC976CC.1080009-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5MNEXMB1qlogic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hal,

At the bottom of this is a slight rewrite of my previous email (and a tweak=
 to the patch) to address your concerns and to make things more clear. Othe=
r items are answered inline.

>What experience/confidence is there in this (specific) randomization=20
>policy ? On what (how large) IB cluster sizes has this policy been tried=20
>? Is this specific policy modeled from other policies in use elsewhere ?

To explicitly discuss this: The old Infinicon stack added 1 second on each =
successive retry, but didn't randomize. I modeled this algorithm after the =
Ethernet model but I chose the terms to be on the same order of magnitude a=
s we typically use for MAD timeouts. I can't claim to have any special expe=
rience showing this particular policy is best except to say that the princi=
ples are sound.

>Also, is this randomized timeout used on RMPP packets if this parameter=20
> is not 0 ?

If the module parameter is non-zero then yes, it will coerce all timeouts f=
or all MAD requests to randomize. Keep in mind that this code doesn't chang=
e how packets are processed when they timeout, it just changes how the time=
out is calculated.

>> Finally, I've added a module parameter to coerce all mad work requests t=
o use this feature if desired.

>On one hand, I don't want to introduce unneeded parameters/complexity=20
>but I'm wondering whether more granularity is useful on which requests=20
>(classes ?) this applies to. For example, should SM requests be=20
>randomized ? This feature is primarily an SA thing although busy can be=20
>used for other management classes but it's use is mainly GS related.

First, I think we should separate this from the BUSY handling issue - not b=
ecause they aren't connected but because every time I start focusing on the=
se things I promptly get yanked onto something else. Hopefully we can focus=
 on just the randomization aspect and bring it to a satisfactory agreement =
first, then I'll re-submit the BUSY handling patch based on that.=20

That said, there's been some argument over whether the best place for choos=
ing the retry policy is in ib_mad or in the individual ulps and apps. The i=
ntent of the module parameter is to provide relief on larger clusters while=
 waiting for the authors of other components to modify their models. I do a=
lso think randomizing on retry is just as applicable for SM requests as for=
 SA - if requests are timing out, then the SA/SM is getting overloaded, reg=
ardless of the type of request.


-----------------------------
Design notes:

This patch builds upon a discussion we had earlier this year on adding a
backoff function when retrying MAD sends after a timeout.

The current behavior is to retry MAD requests at a fixed interval, specifie=
d by
the caller, and no more than the number of times specified by the caller.

The problem with this approach is that if the same application or ulp is
installed on many hundreds (or thousands) of nodes, all using the same retr=
y
interval, they could all end up retrying at roughly the same time, causing
repeatable packet storms. On a large cluster, these storms can effectively =
act
as a denial of service attack. To get around this, the retry timer should h=
ave
a randomization component of a similar order of magnitude as the retries
themselves. Since retries are usually on the order of one second, the patch
defines the randomization component as between zero and roughly 1/2 second
(511 ms) although the upper limit can tuned by changing a #define.

The other standard method for prevent storms of retries is to implement an
exponential backoff, such as is used in the Ethernet protocol. However, bec=
ause
the user has also explicitly specified a timeout value, I chose to treat
that value as a minimum delay, then I add an exponential value on top of th=
at,
defined as BASE*2^c, where 'c' is the number of retries already attempted,
minus 1.

Currently, the base value is defined as 511 ms (1/2 second), so that the
retry interval is defined as:

(minimum timeout) + 511<<c - (random value between 0 & 511)

This causes the following retry times:

0:      minimum timeout
1:      minimum timeout + (random value between 0 & 511)
2:      minimum timeout + 1 second - (random value between 0 & 511)
3:      minimum timeout + 2 seconds - (random value between 0 & 511)
4:      minimum timeout + 4 seconds - (random value between 0 & 511)
.
.
.
c:      minimum timeout + (1/2 second)*2^c - (random value between 0 & 511)

(For comparison, the old Silverstorm/Infinicon stack waited 1 second *
the number of retries.)

------------------------

Implementation:

This patch does NOT implement the ABI/API changes that would be needed to t=
ake
advantage of the new features, but it lays the groundwork for doing so. In
addition, it provides a new module parameter that allow the administrator t=
o
coerce existing code into using the new capability:

parm: randomized_wait: When true, use a randomized backoff algorithm to con=
trol
retries for timeouts. (int)

Note that this parameter will not force retries if the caller specified 0
retries.

Next, I've added a new field called "randomized_wait" to the ib_mad_send_bu=
f
structure. If this parameter is set, each time the WR times out, the timeou=
t
for the next retry is set to

(send_wr->timeout_ms + 511<<(send_wr->retries) - random32()&511).

In other words, on the first retry, the randomization code will add between=
 0
and 1/2 second to the timeout. On the second retry, it will add between 0.5=
 and
1.0 seconds to the timeout, on the 3rd, between 1.5 and 2 seconds, on the 4=
th,
between 3.5 and 4, et cetera. In addition, a new field, total_timeout has b=
een
added to the ib_mad_send_wr_private. My plan is that if the caller specifie=
s=20
randomized retries, total_timeout will be set to send_wr->timeout and=20
send_wr->timeout will be set to the base (default) timeout as its initial=20
value. If randomized_wait is set, total_timeout will instead be set to
(send_wr->timeout * send_wr->max_retries).

In either case, retries cannot exceed this total time, even if that will me=
an a=20
lower number of retry attempts.




--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5MNEXMB1qlogic_
Content-Type: application/octet-stream; name="randomized_mad_timeout.patch"
Content-Description: randomized_mad_timeout.patch
Content-Disposition: attachment; filename="randomized_mad_timeout.patch";
	size=4768; creation-date="Mon, 11 Oct 2010 10:22:01 GMT";
	modification-date="Tue, 02 Nov 2010 16:50:39 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZC5jIGIvZHJpdmVycy9pbmZp
bmliYW5kL2NvcmUvbWFkLmMKaW5kZXggZDVkZmYyYy4uNGYyMzk0YyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9pbmZpbmliYW5kL2NvcmUvbWFkLmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUv
bWFkLmMKQEAgLTQyLDYgKzQyLDExIEBACiAjaW5jbHVkZSAiYWdlbnQuaCIKICNpbmNsdWRlICJs
aW51eC91dHNuYW1lLmgiCiAKKyNpbmNsdWRlICJsaW51eC9yYW5kb20uaCIKKworI2RlZmluZSBN
QURfTUlOX1RJTUVPVVRfTVMgNTExCisjZGVmaW5lIE1BRF9SQU5EX1RJTUVPVVRfTVMgNTExCisK
IE1PRFVMRV9MSUNFTlNFKCJEdWFsIEJTRC9HUEwiKTsKIE1PRFVMRV9ERVNDUklQVElPTigia2Vy
bmVsIElCIE1BRCBBUEkiKTsKIE1PRFVMRV9BVVRIT1IoIkhhbCBSb3NlbnN0b2NrIik7CkBAIC01
NSw2ICs2MCwxMCBAQCBNT0RVTEVfUEFSTV9ERVNDKHNlbmRfcXVldWVfc2l6ZSwgIlNpemUgb2Yg
c2VuZCBxdWV1ZSBpbiBudW1iZXIgb2Ygd29yayByZXF1ZXN0cwogbW9kdWxlX3BhcmFtX25hbWVk
KHJlY3ZfcXVldWVfc2l6ZSwgbWFkX3JlY3ZxX3NpemUsIGludCwgMDQ0NCk7CiBNT0RVTEVfUEFS
TV9ERVNDKHJlY3ZfcXVldWVfc2l6ZSwgIlNpemUgb2YgcmVjZWl2ZSBxdWV1ZSBpbiBudW1iZXIg
b2Ygd29yayByZXF1ZXN0cyIpOwogCitpbnQgbWFkX3JhbmRvbWl6ZWRfd2FpdCA9IDA7Cittb2R1
bGVfcGFyYW1fbmFtZWQocmFuZG9taXplZF93YWl0LCBtYWRfcmFuZG9taXplZF93YWl0LCBpbnQs
IDA0NDQpOworTU9EVUxFX1BBUk1fREVTQyhyYW5kb21pemVkX3dhaXQsICJXaGVuIHRydWUsIHVz
ZSBhIHJhbmRvbWl6ZWQgYmFja29mZiBhbGdvcml0aG0gdG8gY29udHJvbCByZXRyaWVzIGZvciB0
aW1lb3V0cy4iKTsKKwogc3RhdGljIHN0cnVjdCBrbWVtX2NhY2hlICppYl9tYWRfY2FjaGU7CiAK
IHN0YXRpYyBzdHJ1Y3QgbGlzdF9oZWFkIGliX21hZF9wb3J0X2xpc3Q7CkBAIC0xMTM0LDExICsx
MTQzLDI5IEBAIGludCBpYl9wb3N0X3NlbmRfbWFkKHN0cnVjdCBpYl9tYWRfc2VuZF9idWYgKnNl
bmRfYnVmLAogCQl9CiAKIAkJbWFkX3NlbmRfd3ItPnRpZCA9ICgoc3RydWN0IGliX21hZF9oZHIg
Kikgc2VuZF9idWYtPm1hZCktPnRpZDsKKworCQltYWRfc2VuZF93ci0+cmFuZG9taXplZF93YWl0
ID0gbWFkX3JhbmRvbWl6ZWRfd2FpdCB8fCBzZW5kX2J1Zi0+cmFuZG9taXplZF93YWl0OworCQlp
ZiAoc2VuZF9idWYtPnJhbmRvbWl6ZWRfd2FpdCkgeworCQkJLy8gSW4gdGhpcyBtb2RlLCB0aW1l
b3V0X21zIHJlZmVycyB0byB0aGUgdG90YWwgdGltZQorCQkJLy8gdGhlIGNhbGxlciBpcyB3aWxs
aW5nIHRvIHdhaXQgZm9yIGEgcmVwbHksIGFuZCAKKwkJCS8vIHRoZSBpbml0aWFsIHdhaXQgdGlt
ZSBpcyBzZXQgdG8gdGhlIG1pbmltdW0uCisJCQltYWRfc2VuZF93ci0+dG90YWxfdGltZW91dCA9
IG1zZWNzX3RvX2ppZmZpZXMoc2VuZF9idWYtPnRpbWVvdXRfbXMpOworCQkJc2VuZF9idWYtPnRp
bWVvdXRfbXMgPSBNQURfTUlOX1RJTUVPVVRfTVM7CisJCX0gZWxzZSB7CisJCQkvLyBJbiB0aGlz
IG1vZGUsIHRoZSBjYWxsZXIgc3BlY2lmaWVkIGEgc3BlY2lmaWVkIG51bWJlcgorCQkJLy8gb2Yg
cmV0cmllcyBhbmQgdGhlIHRpbWUgdG8gd2FpdCBmb3IgZWFjaCByZXRyeS4KKwkJCW1hZF9zZW5k
X3dyLT50b3RhbF90aW1lb3V0ID0gbXNlY3NfdG9famlmZmllcyhzZW5kX2J1Zi0+dGltZW91dF9t
cykKKwkJCQkJKiBzZW5kX2J1Zi0+cmV0cmllczsKKwkJfQorCQkKIAkJLyogVGltZW91dCB3aWxs
IGJlIHVwZGF0ZWQgYWZ0ZXIgc2VuZCBjb21wbGV0ZXMgKi8KIAkJbWFkX3NlbmRfd3ItPnRpbWVv
dXQgPSBtc2Vjc190b19qaWZmaWVzKHNlbmRfYnVmLT50aW1lb3V0X21zKTsKKwogCQltYWRfc2Vu
ZF93ci0+bWF4X3JldHJpZXMgPSBzZW5kX2J1Zi0+cmV0cmllczsKIAkJbWFkX3NlbmRfd3ItPnJl
dHJpZXNfbGVmdCA9IHNlbmRfYnVmLT5yZXRyaWVzOworCQkKIAkJc2VuZF9idWYtPnJldHJpZXMg
PSAwOworCQkKIAkJLyogUmVmZXJlbmNlIGZvciB3b3JrIHJlcXVlc3QgdG8gUVAgKyByZXNwb25z
ZSAqLwogCQltYWRfc2VuZF93ci0+cmVmY291bnQgPSAxICsgKG1hZF9zZW5kX3dyLT50aW1lb3V0
ID4gMCk7CiAJCW1hZF9zZW5kX3dyLT5zdGF0dXMgPSBJQl9XQ19TVUNDRVNTOwpAQCAtMTg0Niw2
ICsxODczLDcgQEAgc3RhdGljIHZvaWQgaWJfbWFkX2NvbXBsZXRlX3JlY3Yoc3RydWN0IGliX21h
ZF9hZ2VudF9wcml2YXRlICptYWRfYWdlbnRfcHJpdiwKIAogCS8qIENvbXBsZXRlIGNvcnJlc3Bv
bmRpbmcgcmVxdWVzdCAqLwogCWlmIChpYl9yZXNwb25zZV9tYWQobWFkX3JlY3Zfd2MtPnJlY3Zf
YnVmLm1hZCkpIHsKKwogCQlzcGluX2xvY2tfaXJxc2F2ZSgmbWFkX2FnZW50X3ByaXYtPmxvY2ss
IGZsYWdzKTsKIAkJbWFkX3NlbmRfd3IgPSBpYl9maW5kX3NlbmRfbWFkKG1hZF9hZ2VudF9wcml2
LCBtYWRfcmVjdl93Yyk7CiAJCWlmIChtYWRfc2VuZF93cikgewpAQCAtMjQ3NywxNCArMjUwNSwz
OCBAQCBzdGF0aWMgaW50IHJldHJ5X3NlbmQoc3RydWN0IGliX21hZF9zZW5kX3dyX3ByaXZhdGUg
Km1hZF9zZW5kX3dyKQogewogCWludCByZXQ7CiAKLQlpZiAoIW1hZF9zZW5kX3dyLT5yZXRyaWVz
X2xlZnQpCisJaWYgKCFtYWRfc2VuZF93ci0+cmV0cmllc19sZWZ0IHx8IChtYWRfc2VuZF93ci0+
dG90YWxfdGltZW91dCA9PSAwKSkKIAkJcmV0dXJuIC1FVElNRURPVVQ7CiAKIAltYWRfc2VuZF93
ci0+cmV0cmllc19sZWZ0LS07CiAJbWFkX3NlbmRfd3ItPnNlbmRfYnVmLnJldHJpZXMrKzsKIAot
CW1hZF9zZW5kX3dyLT50aW1lb3V0ID0gbXNlY3NfdG9famlmZmllcyhtYWRfc2VuZF93ci0+c2Vu
ZF9idWYudGltZW91dF9tcyk7CisJaWYgKG1hZF9zZW5kX3dyLT5yYW5kb21pemVkX3dhaXQpIHsK
KwkJbWFkX3NlbmRfd3ItPnRpbWVvdXQgPSBtc2Vjc190b19qaWZmaWVzKG1hZF9zZW5kX3dyLT5z
ZW5kX2J1Zi50aW1lb3V0X21zICsKKwkJCShNQURfTUlOX1RJTUVPVVRfTVM8PG1hZF9zZW5kX3dy
LT5zZW5kX2J1Zi5yZXRyaWVzKSAtCisJCQkocmFuZG9tMzIoKSZNQURfUkFORF9USU1FT1VUX01T
KSk7CisJCWlmIChtYWRfc2VuZF93ci0+dGltZW91dCA+IG1hZF9zZW5kX3dyLT50b3RhbF90aW1l
b3V0KSB7CisJCQltYWRfc2VuZF93ci0+dGltZW91dCA9IG1hZF9zZW5kX3dyLT50b3RhbF90aW1l
b3V0OworCQkJbWFkX3NlbmRfd3ItPnRvdGFsX3RpbWVvdXQgPSAwOworCisJCQkvLyBNYWtlIHN1
cmUgd2UgZG9uJ3QgZmFsbCBiZWxvdyB0aGUgbWluaW11bSB0aW1lIG91dC4KKwkJCWlmIChtYWRf
c2VuZF93ci0+dGltZW91dCA8IG1zZWNzX3RvX2ppZmZpZXMoTUFEX01JTl9USU1FT1VUX01TKSkg
eworCQkJCQlyZXR1cm4gLUVUSU1FRE9VVDsKKwkJCX0KKwkJfSBlbHNlIHsKKwkJCW1hZF9zZW5k
X3dyLT50b3RhbF90aW1lb3V0IC09IG1hZF9zZW5kX3dyLT50aW1lb3V0OworCQl9CisJfSBlbHNl
IHsKKwkJbWFkX3NlbmRfd3ItPnRpbWVvdXQgPSBtc2Vjc190b19qaWZmaWVzKG1hZF9zZW5kX3dy
LT5zZW5kX2J1Zi50aW1lb3V0X21zKTsKKwl9CiAKKwlwcmludGsoS0VSTl9ERUJVRyBQRlggIlJl
dHJ5aW5nIHNlbmQgJXA6IHJldHJpZXM6ICV1LCByZXRyaWVzX2xlZnQ6ICV1LCB0aW1lb3V0OiAl
bHUsIHRvdGFsX3RpbWVvdXQ6ICVsdVxuIiwKKwkJbWFkX3NlbmRfd3IsCisJCW1hZF9zZW5kX3dy
LT5zZW5kX2J1Zi5yZXRyaWVzLAorCQltYWRfc2VuZF93ci0+cmV0cmllc19sZWZ0LAorCQltYWRf
c2VuZF93ci0+dGltZW91dCwKKwkJbWFkX3NlbmRfd3ItPnRvdGFsX3RpbWVvdXQpOworCQkKIAlp
ZiAobWFkX3NlbmRfd3ItPm1hZF9hZ2VudF9wcml2LT5hZ2VudC5ybXBwX3ZlcnNpb24pIHsKIAkJ
cmV0ID0gaWJfcmV0cnlfcm1wcChtYWRfc2VuZF93cik7CiAJCXN3aXRjaCAocmV0KSB7CmRpZmYg
LS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWRfcHJpdi5oIGIvZHJpdmVycy9pbmZp
bmliYW5kL2NvcmUvbWFkX3ByaXYuaAppbmRleCA4YjRkZjBhLi4zOTBjOGI4IDEwMDY0NAotLS0g
YS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWRfcHJpdi5oCisrKyBiL2RyaXZlcnMvaW5maW5p
YmFuZC9jb3JlL21hZF9wcml2LmgKQEAgLTEzMyw4ICsxMzMsMTAgQEAgc3RydWN0IGliX21hZF9z
ZW5kX3dyX3ByaXZhdGUgewogCXN0cnVjdCBpYl9zZ2Ugc2dfbGlzdFtJQl9NQURfU0VORF9SRVFf
TUFYX1NHXTsKIAlfX2JlNjQgdGlkOwogCXVuc2lnbmVkIGxvbmcgdGltZW91dDsKKwl1bnNpZ25l
ZCBsb25nIHRvdGFsX3RpbWVvdXQ7CiAJaW50IG1heF9yZXRyaWVzOwogCWludCByZXRyaWVzX2xl
ZnQ7CisJaW50IHJhbmRvbWl6ZWRfd2FpdDsKIAlpbnQgcmV0cnk7CiAJaW50IHJlZmNvdW50Owog
CWVudW0gaWJfd2Nfc3RhdHVzIHN0YXR1czsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvcmRtYS9pYl9t
YWQuaCBiL2luY2x1ZGUvcmRtYS9pYl9tYWQuaAppbmRleCA1OTE2NjE3Li44NTFiM2NhIDEwMDY0
NAotLS0gYS9pbmNsdWRlL3JkbWEvaWJfbWFkLmgKKysrIGIvaW5jbHVkZS9yZG1hL2liX21hZC5o
CkBAIC0yNDYsNiArMjQ2LDcgQEAgc3RydWN0IGliX21hZF9zZW5kX2J1ZiB7CiAJaW50CQkJc2Vn
X2NvdW50OwogCWludAkJCXNlZ19zaXplOwogCWludAkJCXRpbWVvdXRfbXM7CisJaW50CQkJcmFu
ZG9taXplZF93YWl0OwogCWludAkJCXJldHJpZXM7CiB9OwogCg==

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5MNEXMB1qlogic_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
