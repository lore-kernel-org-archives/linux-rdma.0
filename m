From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Fri, 29 Apr 2016 11:01:18 -0600
Message-ID: <CAANLjFqU5WeKk9D1PqnTcSrBojo9WjKNq70soe5rWgyuJ6gsmQ@mail.gmail.com>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
	<5721F149.1090004@grimberg.me>
	<20160428115653.GB21343@leon.nu>
	<CAANLjFo2Riv3anBg99CCd2E_9gmZHrL93ZNT2Od58GMw+TPHpw@mail.gmail.com>
	<CAANLjFrRdcWbC5butmFe29OFZep9RJ-najPAOAq965Y0Jb=i8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFrRdcWbC5butmFe29OFZep9RJ-najPAOAq965Y0Jb=i8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Holger,

Apparently I wasn't properly subscribed to the list (fixed now). I
started by looking at the rxe-dev GitHub repo and copying out the
appropriate files and patching the other files. There was still some
tweaking needed to get it compiled and I then got lost in the
differences between the patches submitted to linux-rdma and what was
in the repo. Then the 4.5 kernel in the repo (possibly based on
linux-next or something) was very different from 4.5 in Linus' repo so
I started going down trying to patch the linux-rdma into that tree.
I'll go back to what I was doing originally. Thanks for the reply.
-----BEGIN PGP SIGNATURE-----
Version: Mailvelope v1.3.6
Comment: https://www.mailvelope.com

wsFcBAEBCAAQBQJXI5NTCRDmVDuy+mK58QAAA7YP/RR7TRIkCtji0aaLOCoV
1dPQcFocY0krCDJ0epWxx2JYqogWIfx4ldu/zhESqOjAjeLyLzgsv+Yi5hYm
5vxpg/5FaGf9hd0EUpnbUroqOgqREG82Wk8QFtZ++ccnyr0dGbKqI75O8q7X
jrSexAfjvUD9kUp7A01e2CWppa0lt3jPD/IHkLzA5MXZl6XPsmiO8X7pJHg+
Lx86VTQ0dL1FuGxNoiH7voNJVFpG+LaMSFZQkYB63wB92iWDDyJoi2XiCG5j
AvELc0sY5Km6d9PUxa/4b6mhJlZgeOUIHfXfID2iduHNn3XIPr8sGTehLMdM
6M2/Ag4fWcRfBFn7xyD/ZPd2YTidOq4zgnrs0VzvqOe2EhQHsikIFn1FkqbM
hg0XrrJE03LLEIB6+cEdJrQQf3cn6qNHLzKR1d/LSCyaPDn4XiAdARPex/+d
mHgqGHTd+XJRrmPvftOidfQr3Y8qoegSIP5kur61w5ucvTsAMZ/xoxjZlCVE
4J8HNvyFZtvaj1qmABgwyT/I2jeGzW1dQ7dXTQQia/VmBkvctSzkik9QyCzk
1xJQaHRul8MPycGcpDjuCmbkzK2dLTEM16uQvEwCon+F1xDd4/9hONX9amP3
IY/rDyA48J/Y1HK3CvzfwtQTySr4YFy+5UlaCwONaUNR6aBGxnTdWm2e1+pA
n/lt
=JPji
-----END PGP SIGNATURE-----
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Apr 28, 2016 at 5:39 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
> Looks like quite a bit has changed especially with
> b7d3e0a94fe128912bbebf0ae68551c85fd2d429 causing those patches to not
> apply cleanly. I'm trying to get this to work on 4.5+, but having
> trouble getting this all figured out (not being a programmer and not
> extremely familiar with the inner workings of RDMA. If someone has a
> newer patch set, I'd like to do some testing.
> -----BEGIN PGP SIGNATURE-----
> Version: Mailvelope v1.3.6
> Comment: https://www.mailvelope.com
>
> wsFcBAEBCAAQBQJXIp8mCRDmVDuy+mK58QAAAwgP+gPby0h66AIYDfzCXv7v
> s+enVrSSCynFxnRALlH5BJjdOZFOaaPQ+K3S9d4w6y8vvszaAdWKJmtabtk2
> jBBQigz7sUI9LjP6Te1VV7e1tjL/b2C/7ieNWCXuZUIQe11ImiaMCYWwwClI
> OsBHYyZTvyW+VjMTNYwmBTUL5mI4yt5MUP0Izj3ZUeQmuhRxqRm3w7ywSjGX
> +8lmFU7Z/oCA8SWIJX5yY0QYfNOLeh/cMPVvXgZwKPnRqqsnO33bGT842UJU
> aQE1YPuLsqFsLTnaVPgqEJAuo2loYdOpCKgIj4MlDu/QSXiOlfBqVDw5DU+c
> Ldj4nIUq4OOdnm9D0IcbgFxSHV17iRhmgaH8oCd3S4lQCtV8FGmS3AN8pVjq
> UMIFIibchEwBI+Q/Xt4Nc00ccU3Cup3jvpWRZw4FXz9GiQQSUPAsdZLMT+Io
> 9dDA7hLCgdeWe8pIjeyqfB8nWxWKppu01Dk4Yyxd08KSoYFa0Lj2wgGOyJqp
> RJ3LxI8IX7eKTgk7Vf/IqorEyka9/KpDNgLxxT2nL6EFKArb626DFgWK+YLG
> 91gocctxebiGEZ6mDAPdMCEYvEyY5KyG1d02Chyl3uiFqJWZMFSwGr+S1Bqa
> WelDLBvjp8xWiqFduZMWv1Z2RibCbh2McsfNXDI5eSU4JyPGhTUBtFddU1Cz
> LcMQ
> =8ZMY
> -----END PGP SIGNATURE-----
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Thu, Apr 28, 2016 at 9:48 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA256
>>
>> Cool, thanks for the update.
>> -----BEGIN PGP SIGNATURE-----
>> Version: Mailvelope v1.3.6
>> Comment: https://www.mailvelope.com
>>
>> wsFcBAEBCAAQBQJXIjDMCRDmVDuy+mK58QAAjcMP/jVRTBSRTJNkhGkGCiL5
>> HbRJUsslKXp61BqL4LnLQ26ELq+YPVvG/ds/7wKAaaQrWv8RZyb+L38J0tI6
>> s9C25Bo+PwheTJHmnTjrL4m0MiEWsiKGHCkc/x98YMla//UHoooE1X1QtJ4w
>> pGNcuF4rgCIoZs8Q8Gd2cIuZWgZUhHNK5TEv866YVXcH1YxkVCKFqen3JD0/
>> 8gtcPv9uw0Try4q584TUjZEEw/7SSy+FAcYDsF84ttUvalwWNcGX/1KR9tf+
>> UVokNxuqpJNEsMqyF+UYg9xFCiBdIbR2KDRd7UVtnJLnfbJd4IFOejxV6x/g
>> MEHFnzckK1pwIT24wEOUedyMELbbPJOfzbw2YzIZH6HAfLi/2a92vlAaW4sy
>> rVAEDBbC+DuXIxhY4DdTw63S4ZS1Tphl8DJmd/PBLMlu9vFS7lay1pZsQ3bQ
>> j7PWhb8h+a2us74xHUfHxd4AoFbRfm5s5EYnlZH/9ho8HiY9vubK3R8ID+ND
>> qYTxLHDSkdccw+AsE+vTXoAFl9vx4nF8F2XQcXlMFjlZ9dmgrVjDIgLbQogb
>> cQI1CunsqwLcYxaPl6W6JLWlEENwagdoSfTDjSZQud8MEQ/LTKipAab2tdmK
>> vD3M9HXyb7oKWrdDfcAhSe/TGcMk8RfaVlPKq3FTVTyhcUQyhKIoNb3iKXoX
>> PDCa
>> =Zzq9
>> -----END PGP SIGNATURE-----
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Thu, Apr 28, 2016 at 5:56 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> On Thu, Apr 28, 2016 at 02:17:29PM +0300, Sagi Grimberg wrote:
>>>>
>>>> >What is the status of getting RXE included in the mainline kernel? I
>>>> >saw a post from Kamal Heib on 22 Sep 2015 with a patchset for
>>>> >inclusion [0], but there didn't seem to be any discussion about it. I
>>>> >diffed the kernel tree with the RXE tree on GitHub using the
>>>> >rxe_submission_v8 branch [1], but there was over 10 million lines in
>>>> >the patch file for the same kernel version. I'd rather patch into the
>>>> >vanilla kernel tree so that I can see the differences rather than just
>>>> >building the tree that someone else provides.
>>>> >
>>>> >I will probably go through all 32 patches anyway, but thought I would
>>>> >prod here about the status as it can be very helpful for
>>>> >compatibility.
>>>>
>>>> FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
>>>> some patches to contribute for it.
>>>
>>> We are planning on submitting it in very near future.
>>>
>>>>
>>>> Cheers,
>>>> Sagi.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
