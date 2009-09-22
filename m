From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: [ofa-general] Re: [PATCH] mlx4: confiugre cache line size
Date: Tue, 22 Sep 2009 21:54:15 +0300
Message-ID: <20090922185415.GA13020@mtls03>
References: <20090916110302.GA32767@mtls03> <adaiqfa7trl.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <adaiqfa7trl.fsf@cisco.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, Eli Cohen <eli@mellanox.co.il>, general-list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 22, 2009 at 10:51:10AM -0700, Roland Dreier wrote:
I agree with you on both comments. Would you like me to resend or will
you make the necessary changes?

> 
>  > +#if defined(cache_line_size)
> 
> Why the #if here?  Do we just need to include <linux/cache.h> explicitly
> to make sure we get the define?
> 
>  > +	*((u8 *) mailbox->buf + INIT_HCA_CACHELINE_SZ_OFFSET) =
>  > +		order_base_2(cache_line_size() / 16) << 5;
> 
> Trivial but I think it's safe to assume a cacheline is always a power of
> 2.  And I think it's clearer (and avoids generating a divide) to use
> subtraction rather than division... so this could all become:
> 
> 		(ilog2(cache_line_size()) - 4) << 5;
> 
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
