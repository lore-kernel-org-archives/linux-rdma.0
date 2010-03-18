From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: adding path record wire format to libibverbs
Date: Thu, 18 Mar 2010 12:20:15 -0600
Message-ID: <20100318182015.GC29129@obsidianresearch.com>
References: <77007DB2D13246B9A031DE3B0094C024@amr.corp.intel.com> <20100318060812.GB28042@obsidianresearch.com> <adar5nh7c6q.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adar5nh7c6q.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 18, 2010 at 10:49:01AM -0700, Roland Dreier wrote:
> Including this structure is no problem in principle.
> 
>  > Could we use the bitfield versions of this I posted awhile back? :)
> 
> I don't have that patch handy, but bitfields often end up ugly with
> endian stuff, and also some compilers/architecture generate awful code
> for it.  What's the advantage over Sean's patch?

It is user space code, the interface should be trivially usable
without a huge hassle to the user. Bitfields can help provide
that. The LE/BE issue is easy to solve, but I admit the solution I
prefer (32 bit byte swap) might not fit very well with Sean's intended
use.

For instance if you want to override the hoplimit to 1:
 pr.flowlabel_hoplimit = htonl((ntohl(pr.flowlabel_hoplimit) & (~0xFF)) | 1);
vs
 swap32_all(&pr, sizeof(pr);
 pr.hopLimit = 1;
 swap32_all(&pr, sizeof(ptr));

For this application I don't think the codegen is a concern, and I've
seen that x86 and ppc generate acceptable code for this.. Certainly,
this approach is definately faster than the pack/unpack scheme I've
seen used in many place.

#ifdef BIG_ENDIAN
struct SAPathRecord {
    uint32_t rsv0;

    uint32_t rsv1;

    uint8_t DGID[16];

    uint8_t SGID[16];

    uint16_t DLID;
    uint16_t SLID;

    uint32_t rawTraffic:1;
    uint32_t rsv2:3;
    uint32_t flowLabel:20;
    uint32_t hopLimit:8;

    uint8_t TClass;
    uint8_t reversible:1;
    uint8_t numbPath:7;
    uint16_t PKey;

    uint16_t rsv3:12;
    uint16_t SL:4;
    uint8_t MTUSelector:2;
    uint8_t MTU:6;
    uint8_t rateSelector:2;
    uint8_t rate:6;

    uint8_t packetLifeTimeSelector:2;
    uint8_t packetLifeTime:6;
    uint8_t preference;
    uint16_t rsv4;

    uint32_t rsv5;
};
#else
// Must ntohl() every 32 bit word prior to appling this structure
struct SAPathRecord {
    uint32_t rsv0;

    uint32_t rsv1;

    uint8_t DGID[16];

    uint8_t SGID[16];

    uint16_t SLID;
    uint16_t DLID;

    uint32_t hopLimit:8;
    uint32_t flowLabel:20;
    uint32_t rsv2:3;
    uint32_t rawTraffic:1;

    uint16_t PKey;
    uint8_t numbPath:7;
    uint8_t reversible:1;
    uint8_t TClass;

    uint8_t rate:6;
    uint8_t rateSelector:2;
    uint8_t MTU:6;
    uint8_t MTUSelector:2;
    uint16_t SL:4;
    uint16_t rsv3:12;

    uint16_t rsv4;
    uint8_t preference;
    uint8_t packetLifeTime:6;
    uint8_t packetLifeTimeSelector:2;

    uint32_t rsv5;
};
#endif

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
