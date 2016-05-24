From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Tue, 24 May 2016 15:17:00 -0400
Message-ID: <a4477030-c966-636e-e395-96857454c7de@redhat.com>
References: <20160519122622.22041.41686.stgit@scvm10.sc.intel.com>
 <20160521123404.GB25500@leon.nu>
 <20160521162301.GA16770@phlsvsds.ph.intel.com>
 <20160522120129.GC25500@leon.nu>
 <20160522140351.GA10696@phlsvsds.ph.intel.com>
 <20160522175715.GD25500@leon.nu>
 <20160523122207.GA16764@phlsvsds.ph.intel.com>
 <20160523130312.GG25500@leon.nu>
 <20160523141049.GE16764@phlsvsds.ph.intel.com>
 <b9dc4ac8-cfa2-d66e-7e36-f28116f23e59@redhat.com>
 <20160524175409.GI25500@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T3xuNx0aVaFPQ7NI6E76eQXIEBctGj3Av"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524175409.GI25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T3xuNx0aVaFPQ7NI6E76eQXIEBctGj3Av
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/24/2016 01:54 PM, Leon Romanovsky wrote:
> On Tue, May 24, 2016 at 12:13:56PM -0400, Doug Ledford wrote:
>> On 05/23/2016 10:10 AM, Dennis Dalessandro wrote:
>>> On Mon, May 23, 2016 at 04:03:12PM +0300, Leon Romanovsky wrote:
>>>> On Mon, May 23, 2016 at 08:22:08AM -0400, Dennis Dalessandro wrote:
>>>>> On Sun, May 22, 2016 at 08:57:15PM +0300, Leon Romanovsky wrote:
>>>>>> On Sun, May 22, 2016 at 10:03:52AM -0400, Dennis Dalessandro wrote=
:
>>>>>>> On Sun, May 22, 2016 at 03:01:29PM +0300, Leon Romanovsky wrote:
>>>>>>>>>> I think the overall consensus over participants in OFVWG call
>>>>> was to use
>>>>>>>>>> one IOCTL to enter into device specific handler which will do =
all
>>>>>>>>>> necessary parsing and not spamming common IOCTL interface.
>>>>>>>>>
>>>>>>>>> That was for the verbs working group and the verbs 2.0 uAPI. Th=
is
>>>>> is for
>>>>>>>>> psm.
>>>>>>>>
>>>>>>>> I'm glad that you are supporting my point.
>>>>>>>> It is vendor specific implementation for vendor specific driver
>>>>> and not
>>>>>>>> for whole IB core, so there is no need to pollute general IB ioc=
tls.
>>>>>>>
>>>>>>> It is making use of and applying a proper classification.  Is the=
re a
>>>>>>> technical concern with this other than that's not how verbs may e=
nd
>>>>> up doing
>>>>>>> it?
>>>>>>>
>>>>>>> I'm not completely opposed to the single ioctl, I just don't
>>>>> necessarily see
>>>>>>> that as better in this case but am willing to listen to a technic=
al
>>>>>>> justification for why it's incorrect.
>>>>>>
>>>>>> it will simplify internal and external development by removing the=

>>>>>> tensions over ioctls numbers. Do you plan to take the block of ioc=
tls
>>>>>> for future expansion? Do you plan to mix hfi's ioctls with verbs's=

>>>>> ioctls
>>>>>> based on acceptance of new code?
>>>>>
>>>>> I'm still not sure what you are getting at here. Can you explain wh=
at
>>>>> you
>>>>> mean by tensions over ioctl numbers?  I guess I don't understand wh=
y the
>>>>> hfi1_x device's use of icotl numbers has any bearing at all on the
>>>>> ibcore/verbs ioctl(s).
>>>>>
>>>>> If and when new code is accepted and hfi1 converges its API to go
>>>>> through a
>>>>> common character device, then hfi1 would surely change to match
>>>>> whatever is
>>>>> there whether that's a single ioctl with a command type embedded or=

>>>>> something that has not even yet been proposed.
>>>>
>>>> Denny,
>>>>
>>>> It is easy for everyone to converge hfi1 API from day one, so if and=

>>>> when new code is posted, the hfi1 changes will be summarized by one
>>>> line change.
>>>
>>> Let's put the future API issue, and the specifics of this patch aside=

>>> for just a minute.  I'd like to understand the rationale for wanting =
a
>>> single ioctl over specific ioctls in the general sense. I know that's=

>>> what folks seem to prefer from the calls, but perhaps we can get that=

>>> down in writing here on the list.
>>>
>>> I see an advantage for the specific ioctls because we can classify th=
em
>>> based on permission. When running things like strace you can decode t=
he
>>> ioctl number and see what access it is making. It also makes it easy =
to
>>> have a gist of what is going on based on the ioctl call itself.
>>
>> Personally, if there is no shortage of ioctls (and there shouldn't be =
in
>> this case because this is ioctls on the psm cdev, not on the uverbs
>> device file), then the separate ioctls have their benefits as Dennis
>> points out.  And seeing as how they (Intel) maintain the psm library
>> that uses this interface, if they want their library using different
>> ioctls and their driver using different ioctls versus one mega ioctl
>> with embedded commands, I'm inclined to let them decide how they want =
it
>> to be.
>=20
> Except one thing that their device should integrate into already
> available char device and don't create new one in IB space.

They have always had their own device.  Until the verbs 2.0 API is moved
forward, I expect them to continue to do so.  That they used the
InfiniBand ioctl number means we might need to make sure that the verbs
2.0 API ioctl numbers and the ones they used don't clash, but given that
we have an assigned range of 256 ioctls and this patchset uses up only
13 (and 13 that could probably be shared with qib), I don't see this as
a starvation of ioctl space issue.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--T3xuNx0aVaFPQ7NI6E76eQXIEBctGj3Av
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRKisAAoJELgmozMOVy/dSu4P/3+0MvW6hGPgOy36Mr8R84F1
W/XV7kRqLFcRaDkz8pBNBhYsKmJFrleifH14k2DZcLUCVSIqJnIoF+xcne8xieHT
IOooQhvDLp9JMU0C3VNrKMQ/gLR37Sd5H7dRioYXkq1yr6d0Wm28b1SNQN7gbSzK
TIDCEvkNKEAyKc+sljO88RTwsslwTTh+iWRO8tAQ24Taz4CBxHB4RQlGdKp8bKvU
FGUxIhpknCGHi5IlYwURYlDER5IpXOH6nQ+ZRJu2dN0Q8U0wB7Hu1+IbmchMf+JJ
D6qOikRidbwvDHb1PITSUknufz2Ag8n11goc9vZmaWCL62kXtjvX9UV8jm1K7DGX
GBvcqWMveP8VohQnrxP6kfvqFGyWVBCPJnC1dAaPNr3OPq+PmwaPPNtnKSjSxk9U
Ux2czYKogVWOLEEiwqXUCw1a07NIqJdda47nf2U6TjF4ee4mAOreWyXZd8qLhzTR
gyitipZFj/v6tcXt9RhT6ldWIOVidiYcNnpxrIKA8WBBcK6ZNnJUKN9em/56Clne
YyGtZSevj2z5aSL1m20h0osWn6T16QKSRQ9tCWMfTV3Xg3VRl5i/ErOrDK8XL/3Y
2yx8bGjwWcnSsjLswk5DTdBQ0tGBufgkNt6fmiId71JlY4VQrROZdbeEuOE38F+D
ooptXiMZMwygXzWZrHY5
=sfsr
-----END PGP SIGNATURE-----

--T3xuNx0aVaFPQ7NI6E76eQXIEBctGj3Av--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
