From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] ABI consistency check
Date: Tue, 14 Nov 2017 20:40:16 +0100
Message-ID: <c2012101-cfaf-b07e-2604-81448c167e23@suse.de>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Between my screwed up Thunderbird that sent the patch from the wrong mail/server and patch #1 which is too big for the ML it seems, I did a PR on github.
https://github.com/linux-rdma/rdma-core/pull/251

Le 14/11/2017 à 19:55, Nicolas Morey-Chaisemartin a écrit :
> Add scripts to generate an ABI dump and compare against a ref.
> Both tools (abi-dumper and abi-consistency-check) were imported as the
> system version do not work on Travis.
> Travis will automatically do that if a ref is present.
> Ref should be added at stable-* branch creation (see doc update)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
