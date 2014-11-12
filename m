From: "Coffman, Jerrie L" <jerrie.l.coffman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/9] Peer-Direct support
Date: Wed, 12 Nov 2014 00:58:25 +0000
Message-ID: <A9EAB01D3BD8F64D8C9802C8BDC0C7F2A61163BC@ORSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 11, 2014 at 12:44 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [...] can you make it easily reviewable? that is, either send as patches to this list or much easier put the relevant piece in public git tree (github?)

While it does take some effort to obtain the code, there are currently no plans to submit patches or create a public git tree for CCL direct until all of the lower level software is upstream.

> Can you point to the missing elements in the chart present @ this LWN post http://lwn.net/Articles/564795/

The CCL direct code depends on a lower level API called the Symmetric Communications Interface (SCIF).  SCIF abstracts the details of communicating over the PCIe bus while providing an API that is symmetric between the host and coprocessor.  The MIC drivers referenced by the LWN post do not include the SCIF API.  Once SCIF is upstream, patches for CCL direct can be submitted.

The point is that there are actual consumers of peer direct that could use it if it were merged upstream.

-jerrie

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
