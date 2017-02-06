From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting next
 week - 2/7/2017 at 11:00PST
Date: Mon, 6 Feb 2017 20:05:13 +0000
Message-ID: <HE1PR0501MB28124EC11E1FB088EA6A821CB1400@HE1PR0501MB2812.eurprd05.prod.outlook.com>
References: <HE1PR0501MB2812A57B3A481B29DE090E2AB14C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <1486074223.2816.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486074223.2816.16.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Bart Van Assche [mailto:Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org]

> Are you aware that Christoph Hellwig's patch series for automatically spr=
eading
> IRQs over CPUs has been accepted upstream some time ago? See also
> pci_alloc_irq_vectors_affinity() in drivers/pci/msi.c. Is the scope of th=
is meeting
> to modify that existing functionality or are you perhaps looking for an A=
PI that
> allows to query the mapping chosen by pci_alloc_irq_vectors_affinity()?
>

Hi Bart, Christoph,

We want to discuss an extension to user-space Verbs, so I think that this h=
as no
direct relation to Christoph's ongoing work.

Obviously, it would impact the ABI, so if the general idea makes sense we w=
ill
continue on the list...

 > Thanks,
>=20
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
