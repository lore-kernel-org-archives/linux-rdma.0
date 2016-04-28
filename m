From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Thu, 28 Apr 2016 09:48:34 -0600
Message-ID: <CAANLjFo2Riv3anBg99CCd2E_9gmZHrL93ZNT2Od58GMw+TPHpw@mail.gmail.com>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
	<5721F149.1090004@grimberg.me>
	<20160428115653.GB21343@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160428115653.GB21343-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Cool, thanks for the update.
-----BEGIN PGP SIGNATURE-----
Version: Mailvelope v1.3.6
Comment: https://www.mailvelope.com

wsFcBAEBCAAQBQJXIjDMCRDmVDuy+mK58QAAjcMP/jVRTBSRTJNkhGkGCiL5
HbRJUsslKXp61BqL4LnLQ26ELq+YPVvG/ds/7wKAaaQrWv8RZyb+L38J0tI6
s9C25Bo+PwheTJHmnTjrL4m0MiEWsiKGHCkc/x98YMla//UHoooE1X1QtJ4w
pGNcuF4rgCIoZs8Q8Gd2cIuZWgZUhHNK5TEv866YVXcH1YxkVCKFqen3JD0/
8gtcPv9uw0Try4q584TUjZEEw/7SSy+FAcYDsF84ttUvalwWNcGX/1KR9tf+
UVokNxuqpJNEsMqyF+UYg9xFCiBdIbR2KDRd7UVtnJLnfbJd4IFOejxV6x/g
MEHFnzckK1pwIT24wEOUedyMELbbPJOfzbw2YzIZH6HAfLi/2a92vlAaW4sy
rVAEDBbC+DuXIxhY4DdTw63S4ZS1Tphl8DJmd/PBLMlu9vFS7lay1pZsQ3bQ
j7PWhb8h+a2us74xHUfHxd4AoFbRfm5s5EYnlZH/9ho8HiY9vubK3R8ID+ND
qYTxLHDSkdccw+AsE+vTXoAFl9vx4nF8F2XQcXlMFjlZ9dmgrVjDIgLbQogb
cQI1CunsqwLcYxaPl6W6JLWlEENwagdoSfTDjSZQud8MEQ/LTKipAab2tdmK
vD3M9HXyb7oKWrdDfcAhSe/TGcMk8RfaVlPKq3FTVTyhcUQyhKIoNb3iKXoX
PDCa
=Zzq9
-----END PGP SIGNATURE-----
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Apr 28, 2016 at 5:56 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Apr 28, 2016 at 02:17:29PM +0300, Sagi Grimberg wrote:
>>
>> >What is the status of getting RXE included in the mainline kernel? I
>> >saw a post from Kamal Heib on 22 Sep 2015 with a patchset for
>> >inclusion [0], but there didn't seem to be any discussion about it. I
>> >diffed the kernel tree with the RXE tree on GitHub using the
>> >rxe_submission_v8 branch [1], but there was over 10 million lines in
>> >the patch file for the same kernel version. I'd rather patch into the
>> >vanilla kernel tree so that I can see the differences rather than just
>> >building the tree that someone else provides.
>> >
>> >I will probably go through all 32 patches anyway, but thought I would
>> >prod here about the status as it can be very helpful for
>> >compatibility.
>>
>> FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
>> some patches to contribute for it.
>
> We are planning on submitting it in very near future.
>
>>
>> Cheers,
>> Sagi.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
