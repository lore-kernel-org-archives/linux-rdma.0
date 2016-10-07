From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bug 176901] New: Running ib_rdma_bw over rxe loopback triggers a
 kernel oops
Date: Fri, 7 Oct 2016 13:12:39 -0400
Message-ID: <4b585ac9-d1a4-a36b-990f-80ebb4bb045d@redhat.com>
References: <bug-176901-11804@https.bugzilla.kernel.org/>
 <CAG53R5X-=b1RFR87ieL4e=ANTV0JfjO6qm8_AdXWeudQQ17oSA@mail.gmail.com>
 <9822c558-91d0-8d6a-8f64-07949d9fdaf7@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KnOCFMEO42t2Dek5aE0h8Iud5p2Uj71ND"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9822c558-91d0-8d6a-8f64-07949d9fdaf7-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KnOCFMEO42t2Dek5aE0h8Iud5p2Uj71ND
Content-Type: multipart/mixed; boundary="RKTsPoBRKgaxFM3m3EruOqxU9EggBTLVN";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>,
 Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <4b585ac9-d1a4-a36b-990f-80ebb4bb045d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bug 176901] New: Running ib_rdma_bw over rxe loopback triggers a
 kernel oops
References: <bug-176901-11804-3bo0kxnWaOQUvHkbgXJLS5sdmw4N0Rt+2LY78lusg7I@public.gmane.org/>
 <CAG53R5X-=b1RFR87ieL4e=ANTV0JfjO6qm8_AdXWeudQQ17oSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <9822c558-91d0-8d6a-8f64-07949d9fdaf7-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <9822c558-91d0-8d6a-8f64-07949d9fdaf7-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--RKTsPoBRKgaxFM3m3EruOqxU9EggBTLVN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/7/2016 12:49 PM, Bart Van Assche wrote:
> On 10/06/16 20:28, Parav Pandit wrote:
>> On Fri, Oct 7, 2016 at 4:53 AM,  <bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org>=

>> wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D176901
>> This bug is fixed with my patch [1] and Doug ack also about merging fi=
x.
>>
>> [1] https://patchwork.kernel.org/patch/9354863/
>=20
> Hello Parav,
>=20
> Thank you for the feedback. Do you perhaps know which branch Doug will
> send to Linus? I haven't found any post-v4.8 rxe changes in Doug's
> for-4.9-good branch:

I had to rebase my k.o/for-4.9 branch.  So, k.o/for-4.9 became
k.o/for-4.9-bad (which has Parav's patches in it), and I made a new
k.o/for-4.9-good that does not have Parav's patches in it.  I then had
to add Parav's patches to my k.o/for-4.9-hfi1 branch (I know, that makes
no sense, but bear with me).  The issue is that the k.o/for-4.9-hfi1
branch needed a very late 4.7-rc base (4.7-rc7 I think) in order for the
hfi1 patches to apply cleanly.  I put Parav's patches into my for-4.9
branch originally, but when I did a merge test with Linus tree, I found
that one of them in particular conflicts with patches that were also
late in the 4.7-rc cycle.  By putting Parav's patches into the hfi1
branch, I can resolve that conflict myself and will be able to send a
clean pull request of just the rxe patches to Linus.  So, long story
short, pull my k.o/for-4.9-hfi1 branch and test against it.

> $ git log --format=3Doneline v4.8..dledford/k.o/for-4.9-good
> drivers/infiniband/sw include/uapi/rdma/*rxe*
> 60747ef4d173c2747bf7f0377fb22846cb422195 Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
>=20
> Something else I was wondering about is whether or not the rdma_rxe
> driver should allow being attached to a bridge interface? Apparently th=
e
> rdma_rxe driver allows attaching to both the non-bridged and the bridge=
d
> interfaces, resulting in duplicate GIDs:
>=20
> # modprobe rdma_rxe
> # brctl addbr virbr0
> # brctl addif virbr0 eth1
> # rxe_cfg add eth1
> # rxe_cfg add virbr0
> # rxe_cfg
>   Name    Link  Driver      Speed  NMTU  IPv4_addr      RDEV  RMTU
>   eth0    yes   virtio_net         1500  192.168.1.123
>   eth1    no    virtio_net         1500                 rxe0
>   virbr0  no    bridge             1500                 rxe1
> # (cd /sys/class/infiniband && grep -aH '' */ports/*/gids/0)
> rxe0/ports/1/gids/0:fe80:0000:0000:0000:5054:00ff:fefd:2e4e
> rxe1/ports/1/gids/0:fe80:0000:0000:0000:5054:00ff:fefd:2e4e
>=20
> Should it ever be allowed that two different ports have the same GID?



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--RKTsPoBRKgaxFM3m3EruOqxU9EggBTLVN--

--KnOCFMEO42t2Dek5aE0h8Iud5p2Uj71ND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX99eHAAoJELgmozMOVy/dSQYP+wZ7YBchKxfn5Fc4ySDlNEUH
LYscomPvVNNsJGD4AlksH9zEFXd+ER44m2P4OEEfYbMpv/QukMHwAcCydXxUsbsN
rLvmusf7a6zlElS+Bl2wXp7c8Gl7W3TiWHAuKvAcDurexhMdyg+DrNABVl7DZ0P+
mpBHwoiZUxs3vOT182sbnfEzjPzo2m3yYpOz1LQkVOH25ainyHINFRm3vbxio6Rw
kpdM58g6gL6y4eAZNEEdc1w/1D/1qn/MRVasmPj2lehgB9YbE4iNkFoAVmCNv6tq
twkSA6XTWcCjx9Lp7fZSdKZFo3WC18RuiRi0DHSm+y2+yg9CPb8/SidyjRSWWsqw
39fEb7DAm5re+STKZjfakC+JUqvJ7Dz1K5jB7krBy3ti85USNNDZdqNWJLCIvIDn
l2L6TLwSv7lTS+KTBTqgwsUO8B4UYUqfJokKOhkl1AhoaiWtXKIgaDVck2jBf5/d
NiZZWkT/pqxG4pVTgv9VBZsfEVs2YMMkdg/kUVlU7U7UuGaMlFgzbnYjJ/7ZOCSm
PTmT4zBbmkscab6Ur+C1qIzXu/h96waah7yplWxr2Rw9lz6tJ9KnPGZjFp8Ludpd
V917zFJpZxyyebByXM1PRqnJ5pslSBrGpyI95O8IuXReuVakKWvP/DtTkb29WdCa
aQ3jskGow9R7sS6RMwcf
=msDX
-----END PGP SIGNATURE-----

--KnOCFMEO42t2Dek5aE0h8Iud5p2Uj71ND--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
