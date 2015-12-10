From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Thu, 10 Dec 2015 12:17:28 -0500
Message-ID: <5669B3A8.9090801@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <20151208230244.GA10701@infradead.org>
 <20151209005203.GD16976@phlsvsds.ph.intel.com>
 <20151209184235.GB4522@infradead.org>
 <20151210014556.GA32059@phlsvsds.ph.intel.com>
 <56693758.90808@dev.mellanox.co.il>
 <93E3DE8A-0589-436D-A9A1-7EAC66B12739@oracle.com>
 <004f01d13365$45535e20$cffa1a60$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vwxqPC156n7adLDv6tE2rX4NmtLCpLqKS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004f01d13365$45535e20$cffa1a60$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "'ira.weiny'" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Or Gerlitz' <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vwxqPC156n7adLDv6tE2rX4NmtLCpLqKS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/10/2015 11:10 AM, Steve Wise wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.k=
ernel.org] On Behalf Of Chuck Lever
>> Sent: Thursday, December 10, 2015 10:08 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: ira.weiny; Christoph Hellwig; Jason Gunthorpe; Or Gerlitz; Steve W=
ise; Or Gerlitz; Sagi Grimberg; Doug Ledford
>> Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctl=
y)
>>
>>
>>> On Dec 10, 2015, at 3:27 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>>>
>>>
>>>
>>>> Doug this is going to conflict with the rdmavt work.  So if you take=
 this could
>>>> you respond on the list.
>>>
>>> It will also conflict with the iser remote invalidate series.
>>>
>>> Doug it would help if you share your plans so people can rebase
>>> accordingly.
>>
>> I would be remiss not to mention that it probably also
>> conflicts with the NFS server bi-directional RPC/RDMA
>> series.
>>
>> Invasive IB core changes like this clean up are especially
>> burdensome for me because NFS/RDMA changes do not normally
>> go through Doug's tree, so it takes extra co-ordination.
>>
>> Here is a modest proposal. An obvious way to split the
>> device attr cleanup might go like this:
>>
>> a. first patch: add new fields to ib_device
>> b. then one patch for each provider to populate these fields
>> c. then one patch for each kernel ULP to use the new fields
>> d. then one patch for each provider to remove ->query_attr
>> e. last patch: remove ib_device_attr from the IB core
>>
>> That way each provider and ULP maintainer can review and
>> ack the portion of the changes that he or she is responsible
>> for, and it should help make it much easier to merge with
>> conflicting changes.
>>
>> Splitting it across more than one kernel release would be
>> helpful too, IMO. a. and b. can go into 4.5, c. into 4.6,
>> and d. and e. can go in any time after that.
>>
>> This adds more "process" but given the long chain of core
>> changes now in plan, we should acknowledge how disruptive
>> they will be, and come up with ways to make it possible to
>> get other work done while the core maintenance work
>> progresses.
>>
>>
>=20
> The approach sounds reasonable to me.

This isn't a bad plan if we go that way.

Now here's where I get to speak my mind on things (since people have
been asking).


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--vwxqPC156n7adLDv6tE2rX4NmtLCpLqKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWabOoAAoJELgmozMOVy/dlZcP/2uIf95uh+Zqrrzork024c42
j8hG+9nIoEd3kR7jgFNmvmxNYGwC3+UWdRD/4v8n1WHNLWfvkc07SuhD5hx/8rHZ
4jm5O0kBNmBddBXl1gpbOsVvkKBvGEAKMomHWE1zywAA+I4/cUAZDZY1QkHmwEtT
WVx13yDl3BZ/wwc/1xeMCT5w/lm/L1+m+7ure3MXoOe7+A6wFHm33xd+ZhEzuZh4
Y1ehGL+4VHgTfCX3BN4SOd8NkmHUneoYWoXXtTH//sYR5PcxBwpOcEbPlMNefC7K
cMh4QqbBVC177Mcb/QrgVxp+R8w+P4A6umad61iQQngJbQLE9QTRBSrY1WGQdiJY
H3mc2kDTeubHkxtFDe6Za8yNAUZg0qw+iOLRFcvivm3d2/8RECnerFcpPqkKpHJp
xN39BI4Xnv+BKzP5+ciLr/UcIF9lx0KuSr94r1ecxK6xo8HmJIAo/p59Onu24TP/
0sRGaQMaw2YTlEygEbT5vF4kKcIKT9RTrp0Qubprm9HqHF/znY00lChX0e91jrws
ou9cHlyyfYoUkQI/eqQyV3uOqcC7GQRbKH1Lhq6Bs6ICxllNIXGhRPYzaw6zC8B4
VTkhN3ut54EojOZbfNF/rx6vfvUl8+H1i5sFKudcrGsACvbZdfw0YeQtnqtGVdCY
aGCd6AXwUZtC6giVAV9t
=DI4G
-----END PGP SIGNATURE-----

--vwxqPC156n7adLDv6tE2rX4NmtLCpLqKS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
