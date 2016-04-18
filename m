From: okaya@codeaurora.org
Subject: Re: [PATCH V2] net: ethernet: mellanox: correct page conversion
Date: Mon, 18 Apr 2016 09:06:18 -0400
Message-ID: <0c6a430c5f0ec64f51d7c594ef9751dd@codeaurora.org>
References: <1460845412-13120-1-git-send-email-okaya@codeaurora.org>
 <20160418121247.GA25387@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20160418121247.GA25387@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-rdma@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, Yishai Hadas <yishaih@mellanox.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2016-04-18 08:12, Christoph Hellwig wrote:
> On Sat, Apr 16, 2016 at 06:23:32PM -0400, Sinan Kaya wrote:
>> Current code is assuming that the address returned by 
>> dma_alloc_coherent
>> is a logical address. This is not true on ARM/ARM64 systems.
> 
> Can you explain what you mean with a 'logical address' and what actual
> issue you're trying to solve?

Vmap call is failing on arm64 systems because dma alloc api already 
returns an address mapped with vmap.

Please see arch/arm64/mm directory.
