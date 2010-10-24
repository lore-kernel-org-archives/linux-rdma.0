From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 4/12] ib-mgmt: Add basic SM definitions to umad
Date: Sat, 23 Oct 2010 20:27:31 -0600
Message-ID: <20101024022731.GA842@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7F3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7F3-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 23, 2010 at 12:03:18AM -0700, Hefty, Sean wrote:

> +struct umad_smp {
> +	uint8_t	 base_version;
> +	uint8_t	 mgmt_class;
> +	uint8_t	 class_version;
> +	uint8_t	 method;
> +	uint16_t status;
> +	uint8_t  hop_ptr;
> +	uint8_t  hop_cnt;
> +	uint64_t tid;
> +	uint16_t attr_id;
> +	uint16_t resv;
> +	uint32_t attr_mod;
> +	uint64_t mkey;

These uint64_t's should also be the special 64 bit type I mentioned
before. The problem here is that uint64_t increases the alignment
requirement of the struct to 8, while its natural place, in say, an IB
packet (LRH+BTH+DETH+SMP) only has an alignment of 4.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
