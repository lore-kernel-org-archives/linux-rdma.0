From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] ib_srpt: Update encode_wr_id() argument type
Date: Sat, 12 Nov 2011 12:47:18 -0800
Message-ID: <1321130838.22109.41.camel@haakon2.linux-iscsi.org>
References: <201111111215.14297.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <201111111215.14297.bvanassche@acm.org>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2011-11-11 at 12:15 +0100, Bart Van Assche wrote:
> Since commit 6b7227866 the first argument passed to encode_wr_id()
> is always of type enum srpt_opcode. Make this explicit by updating
> the function declaration. Also insert a blank line between
> function definitions as is done in the rest of the Linux kernel.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Roland Dreier <roland@purestorage.com>
> Cc: Christoph Hellwig <hch@infradead.org>

Series applied.

Thanks Bart!

--nab
