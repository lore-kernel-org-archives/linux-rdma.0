From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Sparse fixes for 4.12
Date: Fri, 28 Apr 2017 13:13:22 -0400
Message-ID: <1493399602.3041.160.camel@redhat.com>
References: <20170422142852.18882-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170422142852.18882-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-04-22 at 17:28 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> Please find below 4 patches, which fix 45 sparse warnings.
> 
> Patches #1 and #2 are trivial changes. The first adds static keyword
> to the functions declarations and second adds includes of the
> relevant
> headers.
> 
> Patch #3 refactors code to get rid of one temporal variable. That
> variable
> was needed to determine if QP is found. Once removed, it allowed to
> write
> the code with lock and unlock placed together.
> 
> Patch #4 fixes wrong type casting. The opcode is in CPU format and
> wqe_word
> is in le32 format.
> 
> This series is based on k.o/for-4.12-rdma-netdevice branch.

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
