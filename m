From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Thu, 30 Jul 2015 11:51:12 -0400
Message-ID: <55BA47F0.5080504@redhat.com>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
 <1438264693.9344.19.camel@opteya.com> <20150730152049.GA29102@yuval-lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SOVlnMxRa4UC6tiOc1MJS9V3RSqRcq9Jp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730152049.GA29102@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SOVlnMxRa4UC6tiOc1MJS9V3RSqRcq9Jp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 11:20 AM, Yuval Shaia wrote:
> On Thu, Jul 30, 2015 at 03:58:13PM +0200, Yann Droneaud wrote:
>> Hi,
>>
>> Le jeudi 30 juillet 2015 =E0 04:46 -0700, Yuval Shaia a =E9crit :
>>> This enhancement suggest the usage of IB CRC instead of CSUM in IPoIB=
=20
>>> CM. IPoIB CM uses RC (Reliable Connection) which guarantees the=20
>>> corruption free delivery of the packet.
>>>
>>> InfiniBand uses 32b CRC which provides stronger data integrity=20
>>> protection compare to 16b IP Checksum.
>>
>> InfiniBand 32b CRC <=3D> Ethernet 32b CRC, it's link layer, layer 2.
>>
>> IPv4 checksum is at another level, it's internet layer, layer 3.
>>
>>>  So, there is no added value that IP/TCP Checksum provides in the IB =

>>> world.
>>>
>>
>> Sure, IPv4 checksum is a thing of the past: checksum was dropped from
>> IP header in IPv6: it assumes the lower layer, such as Ethernet,
>> provides the required integrety check.
>>
>> I think not checking the IPv4 checksum should be a choice, carefully
>> thought, for inside a fabric, as I understand your proposal, packet
>> with invalid checksum will be allowed to go in/out of the fabric.
> Yes, this is why it is controlled by module parameter.
> Maybe a better choice would be to default it to 0.

In it's current form, yes, it should default to 0.

>>
>> It sound like it's a departure from the behavior one can expect from a=
n
>> IPv4 network stack.
> It should be considered as network-fine-tuning parameter so if admin kn=
ows his fabric he can use it.
>>
>>> The proposal is to tell network stack that IPoIB-CM supports IP=20
>>> Checksum offload. This enables the kernel to save the time of=20
>>> checksum calculation of IPoIB CM packets. Network sends the IP packet=
=20
>>> without adding the IP Checksum to the header. On the receive side,=20
>>> IPoIB driver again tells the network stack that IP Checksum is good=20
>>> for the incoming packets and network stack avoids the IP Checksum=20
>>> calculations.
>>>
>>> During connection establishment the driver determine if peer supports=

>>> IB CRC as checksum. This is done so driver will be able to calculate
>>> checksum before transmiting the packet in case the peer does not=20
>>> support this feature.
>>>
>>
>> Two questions:
> Three :)

No, he really only had 2, the second one was a line split of the word
checksum-less done by his mailer ;-)

>>
>> - What will see tool such as wireshark/tcpdump when sniffing checksum
> Zero or what ever the networking layer puts in csum when H/W supports C=
SUM-offloading.
> Please note that with this patch driver still supports backward computa=
bility (per connection).
> This means that for connections with peer which does not support this f=
unctionality you expect to see this value filled with checksum.
>> -less IPv4 packets sent/received on IPoIB interface ?
> No
>>
>> - What might happen if such checksum-less IPv4 packet is later routed =
to a different IPv4 network ?
> As noted above, for network that is opened to outside world this featur=
e should be blocked.
> In general i would say that if a layer 2 terminator device (e.x router)=
 exist in the fabric - this feature can't be used and must be blocked.
> With this limitation it still worth use it because of the reason of inc=
reasing throughput

In its current state, I have my doubts about this patch.  However, it
seems to me that this should be relatively easy to fix in such a way
that you get 90%+ of the performance benefit, and can turn it on by
default, and we don't cause any problems.  Why not perform the checksum
operation on a per connection basis?  This is all IPoIB traffic anyway,
so every send will have a src ip and dst ip.  If the dst ip is link
local to our src ip device, and the connected mode partner is capable of
running without csum, then send that specific packet without doing a
checksum.  If the IP address is not link local, then do the checksum as
normal.  That way if our final destination is on the other side of a
router, we aren't leaking un-checksummed packets.  It means we would
miss out on being able to do checksum-less transfers from host A on
fabric 0 through host B as a router to host C on fabric 1, but I doubt
that's a very common situation to be in.  Or maybe a better way of
putting this is if our next hop IP address !=3D our dest IP address, then=

perform the checksum, otherwise if capable of checksum-less operation,
do so.  Can you rework the patch to operate in that manner?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SOVlnMxRa4UC6tiOc1MJS9V3RSqRcq9Jp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVukfwAAoJELgmozMOVy/d3QwP/1gu+pz2JrejMefqYSIyCya2
L4FSs/B+XceeAEGHv4KQ5s3/Rn05B2LcHyG7J8KTHUmsJd45ENFtSK9X1+zoPfLJ
Lu8O5zICBNK798UL9ye+EVFXXZzXRVqYQB7PBzHGSdmBPNw72x9Tn2Jny/n0/+4h
6iks4fsVTKpGwWKHUuvbd9BB9h2nd8I2ml/BNlyOCOltVJhNXP5U4bn79QV0+Y23
EeDslgsU3OQ3gTPbX436F09sDx0ZKBTyOM2BEl9+zle+TCFRTZBxA57yiTxNPMgG
M8CDdSDmypth+4taUl085j/paFxG5LmkAoRC4T9I/nuMkGHfZ6BPU1wmjV9hfxzE
igoVmb8irCt4ojSmxp9KlfpnsA0hjTtK5Lm5sTD6RQVw6IajOnP44yyojQNlJaGW
H9M27FszrrSMo5DB/boBkXBnL9iHVV5a9hvHBtsov9+B6jk6GjCn5kpTGgGLucq/
BRFYKcu5cEOoYgZ+zZU1vXvT4Z0Keb4KJiMBAv7CdaM2hV/Rd0gah1iLguafMxvg
DmydW4fpAV51AID2wjThGZHCQJN0FTPHpFoUA0cMg9U1soqkypbYKckK32mi4WFh
X2nUtEL9v1PhiemtA6Qt6I648GLsDAuIth2uOWatrh0Q2j7SRuQ7rNHOF0juYfTY
sNIScjKScOOZUrSS9EbI
=Um+Y
-----END PGP SIGNATURE-----

--SOVlnMxRa4UC6tiOc1MJS9V3RSqRcq9Jp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
