From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Trouble enabling iSER for ConnectX-4 Lx
Date: Thu, 27 Oct 2016 14:15:20 -0600
Message-ID: <CAANLjFrCsWuapKU1-coEj_ro+BcQE_bOGb7d4+VDkEKZRG5aPw@mail.gmail.com>
References: <CAANLjFr_we+33Nen-NYp1xQPzQ-wbR=GL4LBkEZb9azMUN-_=Q@mail.gmail.com>
 <ba970fe1-52cd-9f8d-c48d-5eac76b5bfa2@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ba970fe1-52cd-9f8d-c48d-5eac76b5bfa2-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Installing Mellanox OFED and not just the Ethernet drivers cleared
things up. We have a handful of patches that are required for products
we are developing and a few patches that are trying to resolve iSER D
state issues we are seeing (which may not even be useful while using
iSER from Mellanox OFED).

Now I have to see if there will be issues with the Qloic FastLinq card
with the Mellanox OFED. I don't think we will have both cards in
production, just as we are trying to settle on hardware and protocols.

Thank you,
Robert LeBlanc
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Oct 27, 2016 at 2:48 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> Hi Robert,
>
> AFAIK, MLNX_OFED does includes isert only for specific distros.
>
> This is probably a compat issue between stock isert and MLNX
> provided RDMA stack.
>
> Any specific reason not to use upstream (or stock 4.4.27) kernel?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
