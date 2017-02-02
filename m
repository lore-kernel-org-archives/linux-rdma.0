From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 next week - 2/7/2017 at 11:00PST
Date: Thu, 2 Feb 2017 22:24:16 +0000
Message-ID: <1486074223.2816.16.camel@sandisk.com>
References: <HE1PR0501MB2812A57B3A481B29DE090E2AB14C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0501MB2812A57B3A481B29DE090E2AB14C0-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Content-ID: <8EC5D3DF27CF66489CE7D6AECD7A9DFD-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-02 at 22:17 +0000, Liran Liss wrote:
> We would like to solicit a discussion next week on an API proposal
> for binding RDMA completion vectors to CPUs.

Hello Liran,

Are you aware that Christoph Hellwig's patch series for automatically
spreading IRQs over CPUs has been accepted upstream some time ago? See
also pci_alloc_irq_vectors_affinity() in drivers/pci/msi.c. Is the scope
of this meeting to modify that existing functionality or are you perhaps
looking for an API that allows to query the mapping chosen by
pci_alloc_irq_vectors_affinity()?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
