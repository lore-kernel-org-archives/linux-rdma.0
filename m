From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH rfc 02/10] nvme-pci: Add budget to __nvme_process_cq
Date: Thu, 9 Mar 2017 14:46:15 +0100
Message-ID: <d3664ffa-4781-83b6-276c-a935d7ce9723@suse.de>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-3-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-3-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 03/09/2017 02:16 PM, Sagi Grimberg wrote:
> Prepare to allow passing a batch size to nvme cq processing.
> 
> This patch does not change an functionality.
> 
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---

I think I already did this with the 1st RFC (this patch gives me a deja
vu moment), but:
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
