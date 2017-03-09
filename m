From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH rfc 09/10] nvmet: Use non-selective polling
Date: Thu, 9 Mar 2017 14:54:47 +0100
Message-ID: <74284e7b-ae3f-4bbd-c28a-2dccab58cdc0@suse.de>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-10-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-10-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 03/09/2017 02:16 PM, Sagi Grimberg wrote:
> It doesn't really make sense to do selective polling
> because we never care about specific IOs. Non selective
> polling can actually help by doing some useful work
> while we're submitting a command.
> 
> We ask for a batch of (magic) 4 completions which looks
> like a decent network<->backend proportion, if less are
> available we'll see less.
> 
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---

Just out of curiosity, how did you come up with the magic 4?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
