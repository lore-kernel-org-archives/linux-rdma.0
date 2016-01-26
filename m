From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Remote access to pmem on storage targets
Date: Tue, 26 Jan 2016 10:29:35 -0500
Message-ID: <D0C5C0B9-A1A2-4428-B3CA-7BBCC5BEF10D@oracle.com>
References: <06414D5A-0632-4C74-B76C-038093E8AED3@oracle.com> <5FD20017-B588-42E6-BBDA-2AA8ABDBA42B@ornl.gov>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5FD20017-B588-42E6-BBDA-2AA8ABDBA42B-1Heg1YXhbW8@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: "lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jan 26, 2016, at 10:25 AM, Atchley, Scott <atchleyes-1Heg1YXhbW8@public.gmane.org> wro=
te:
>=20
>> On Jan 25, 2016, at 4:19 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>=20
>> I'd like to propose a discussion of how to take advantage of
>> persistent memory in network-attached storage scenarios.
>>=20
>> RDMA runs on high speed network fabrics and offloads data
>> transfer from host CPUs. Thus it is a good match to the
>> performance characteristics of persistent memory.
>>=20
>> Today Linux supports iSER, SRP, and NFS/RDMA on RDMA
>> fabrics. What kind of changes are needed in the Linux I/O
>> stack (in particular, storage targets) and in these storage
>> protocols to get the most benefit from ultra-low latency
>> storage?
>>=20
>> There have been recent proposals about how storage protocols
>> and implementations might need to change (eg. Tom Talpey's
>> SNIA proposals for changing to a push data transfer model,
>> Sagi's proposal to utilize DAX under the NFS/RDMA server,
>> and my proposal for a new pNFS layout to drive RDMA data
>> transfer directly).
>>=20
>> The outcome of the discussion would be to understand what
>> people are working on now and what is the desired
>> architectural approach in order to determine where storage
>> developers should be focused.
>>=20
>> This could be either a BoF or a session during the main
>> tracks. There is sure to be a narrow segment of each
>> track's attendees that would have interest in this topic.
>>=20
>> --
>> Chuck Lever
>=20
> Chuck,
>=20
> One difference on targets is that some NVM/persistent memory may be b=
yte-addressable while other NVM is only block addressable.
>=20
> Another difference is that NVMe-over-Fabrics will allow remote access=
 of the target=E2=80=99s NVMe devices using the NVMe API.

As I understand it, NVMf devices look like local devices.
NVMf devices need globally unique naming to enable safe use
with pNFS and other remote storage access protocols.

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
