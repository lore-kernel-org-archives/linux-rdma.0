From: Aaron Knister <aaron.s.knister@nasa.gov>
Subject: Re: [PATCH] avoid race condition between start_xmit and
 cm_rep_handler
Date: Thu, 16 Aug 2018 09:04:32 -0400
Message-ID: <9f11633d-1473-d04b-edf2-ad2fdc8b411e@nasa.gov>
References: <1534381909-2219-1-git-send-email-aaron.s.knister@nasa.gov>
 <20180816045402.GB4886@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature";
        boundary="e6Z7QN5cP3F4fkceYBQ2PNLSRDx4wa8Y1"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180816045402.GB4886@mtr-leonro.mtl.com>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>
List-Id: linux-rdma@vger.kernel.org

--e6Z7QN5cP3F4fkceYBQ2PNLSRDx4wa8Y1
Content-Type: multipart/mixed; boundary="yeWZVI2tKQRSXhsu3Od0nUeMsjdOq1fVS";
 protected-headers="v1"
From: Aaron Knister <aaron.s.knister@nasa.gov>
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>
Message-ID: <9f11633d-1473-d04b-edf2-ad2fdc8b411e@nasa.gov>
Subject: Re: [PATCH] avoid race condition between start_xmit and
 cm_rep_handler
References: <1534381909-2219-1-git-send-email-aaron.s.knister@nasa.gov>
 <20180816045402.GB4886@mtr-leonro.mtl.com>
In-Reply-To: <20180816045402.GB4886@mtr-leonro.mtl.com>

--yeWZVI2tKQRSXhsu3Od0nUeMsjdOq1fVS
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/16/18 12:54 AM, Leon Romanovsky wrote:
> On Wed, Aug 15, 2018 at 09:11:49PM -0400, Aaron Knister wrote:
>> Inside of start_xmit() the call to check if the connection is up and t=
he
>> queueing of the packets for later transmission is not atomic which
>> leaves a window where cm_rep_handler can run, set the connection up,
>> dequeue pending packets and leave the subsequently queued packets by
>> start_xmit() sitting on neigh->queue until they're dropped when the
>> connection is torn down. This only applies to connected mode. These
>> dropped packets can really upset TCP, for example,  and cause
>> multi-minute delays in transmission for open connections.
>>
>> I've got a reproducer available if it's needed.
>>
>> Here's the code in start_xmit where we check to see if the connection
>> is up:
>>
>>         if (ipoib_cm_get(neigh)) {
>>                 if (ipoib_cm_up(neigh)) {
>>                         ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
>>                         goto unref;
>>                 }
>>         }
>>
>> The race occurs if cm_rep_handler execution occurs after the above
>> connection check (specifically if it gets to the point where it acquir=
es
>> priv->lock to dequeue pending skb's) but before the below code snippet=

>> in start_xmit where packets are queued.
>>
>>         if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {=

>>                 push_pseudo_header(skb, phdr->hwaddr);
>>                 spin_lock_irqsave(&priv->lock, flags);
>>                 __skb_queue_tail(&neigh->queue, skb);
>>                 spin_unlock_irqrestore(&priv->lock, flags);
>>         } else {
>>                 ++dev->stats.tx_dropped;
>>                 dev_kfree_skb_any(skb);
>>         }
>>
>> The patch re-checks ipoib_cm_up with priv->lock held to avoid this
>> race condition. Since odds are the conn should be up most of the time
>> (and thus the connection *not* down most of the time) we don't hold th=
e
>> lock for the first check attempt to avoid a slowdown from unecessary
>> locking for the majority of the packets transmitted during the
>> connection's life.
>>
>> Cc: stable@vger.kernel.org
>> Tested-by: Ira Weiny <ira.weiny@intel.com>
>> Signed-off-by: Aaron Knister <aaron.s.knister@nasa.gov>
>> ---
>=20
> Sorry, but no mainly for two reasons:
> 1. Don't lock/unlock in different functions.
> 2. Don't create unbalanced number of lock/unlocks.
>=20
> Thanks
>=20

Thanks, Leon. I'm on-board with not locking/unlocking between functions. =
That felt a little weird, and I think I can work around that. I'm curious=
, though, about the unbalanced number of lock/unlocks because I don't see=
 that looking at the patch. Could you help me understand your concern? Ha=
ving said that, this struck me as appearing unbalanced:

+		spin_lock_irqsave(&priv->lock, flags);
+		if (ipoib_cm_up(neigh)) {
+			spin_unlock_irqrestore(&priv->lock, flags);
+			ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
+		} else  {
+			defer_neigh_skb(skb, dev, neigh, phdr, &flags);
+		}

but that call to defer_neigh_skb would call spin_unlock_irqrestore becaus=
e it passes in &flags to defer_neigh_skb. It's not obvious, though, which=
 is probably an issue. I'm trying to balance only holding priv->lock wher=
e absolutely necessary with not typing chunks of code out twice but with =
subtle differences.

I'll re-work this and re-submit.

-Aaron

--=20
Aaron Knister
NASA Center for Climate Simulation (Code 606.2)
Goddard Space Flight Center
(301) 286-2776


--yeWZVI2tKQRSXhsu3Od0nUeMsjdOq1fVS--

--e6Z7QN5cP3F4fkceYBQ2PNLSRDx4wa8Y1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIzBAEBCgAdFiEEeZx9y0IOxOBd7OSzYpKCok98U7QFAlt1dmEACgkQYpKCok98
U7TcxxAAiXX/I2930qINdLSQcbNYLwO2KNovM0HR2TxABuv/N1qT62x4WAzELXuD
hldVAkvrGYYdosVrLKY+lwFuGrebwhcJ6grCL/yo/yXSZZzIfuYkkty3PyCLaCPZ
MQgEsLsrJiA555gtuS7vd0njWURSd/noSn09FEGXEE7ErB/HS5wVrSY/vbnTWHeW
9czGDo8sA9xfxtpFw/EidMapVp8jJzrvW3fsDreInA0PHpy3xDM1PiIe6WGxxayd
XLCdZeAvIQGeNumU48BMzbdCOFbIQ14/hP5WYusYg8NX9/EpKMvusa4spnX7MgQS
XriK3/kJyVzzpbjaKkDblPfqGX1yuTFAfNy4w5oJwaQQe4ENpFobBSq2+hnyRaOx
D2H73/wT18itat7nUcfQZTNPbT5aLoS9ZyVIrmUUb+jT698LBgskQjTeYQZBdgbI
d/Qi2CkioULPUBCFyymPNZRGL5HVxSgI6HjrThN7HyxCZgENYXCVtlSjRDvJoU//
noj7QtsHBDV0wHLLDcehlHpwN4pHTyIvbOQy1rjni8iCgXOZrP/m+zWCqWpiSvp7
mgU5xJjaFKS8Rqn/E9d7I5T+j6+22Uo8GY1XWuSzoPe8fSr1SOq/4tZLvROL/Z2q
TUR3gh7/D+Xx+5WolYLdWmKvozAKJACY5yf7sLEEQQnfT8wyVP0=
=KffR
-----END PGP SIGNATURE-----

--e6Z7QN5cP3F4fkceYBQ2PNLSRDx4wa8Y1--
