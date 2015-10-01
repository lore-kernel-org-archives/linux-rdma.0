From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5 RFC] IB/mad: Add umad trace points
Date: Thu, 1 Oct 2015 14:06:04 +0800
Message-ID: <201510011425.XHuYwDxJ%fengguang.wu@intel.com>
References: <1443675089-11786-5-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443675089-11786-5-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be64
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be16
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: cast to restricted __be32
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] qpn
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] qpn
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] qkey
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] qkey
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] lid
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] lid
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] flow_label
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] flow_label
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] mad_status
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] status
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] class_specific
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] class_specific
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned long long [unsigned] [usertype] tid
   include/trace/events/ib_umad.h:42:1:    got restricted __be64 [usertype] tid
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] attr_id
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] attr_id
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] attr_mod
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] attr_mod
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] qpn
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] qpn
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] qkey
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] qkey
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] lid
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] lid
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] flow_label
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] flow_label
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] mad_status
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] status
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] class_specific
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] class_specific
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned long long [unsigned] [usertype] tid
   include/trace/events/ib_umad.h:42:1:    got restricted __be64 [usertype] tid
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned short [unsigned] [usertype] attr_id
   include/trace/events/ib_umad.h:42:1:    got restricted __be16 [usertype] attr_id
>> include/trace/events/ib_umad.h:42:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_umad.h:42:1:    expected unsigned int [unsigned] [usertype] attr_mod
   include/trace/events/ib_umad.h:42:1:    got restricted __be32 [usertype] attr_mod

vim +42 include/trace/events/ib_umad.h

    26	 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
    27	 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
    28	 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    29	 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    30	 * SOFTWARE.
    31	 *
    32	 */
    33	
    34	#undef TRACE_SYSTEM
    35	#define TRACE_SYSTEM ib_umad
    36	
    37	#if !defined(_TRACE_IB_UMAD_H) || defined(TRACE_HEADER_MULTI_READ)
    38	#define _TRACE_IB_UMAD_H
    39	
    40	#include <linux/tracepoint.h>
    41	
  > 42	DECLARE_EVENT_CLASS(ib_umad_write_template,
    43		TP_PROTO(struct ib_umad_file *file, struct ib_user_mad *mad),
    44		TP_ARGS(file, mad),
    45	
    46		TP_STRUCT__entry(
    47			__array(char,           dev_name, IB_DEVICE_NAME_MAX )
    48			__field(u8,             port_num                     )
    49	
    50			__field(u32,            id                           )

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
