From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC 1/2] Protect larger order pages from breaking up
Date: Fri, 16 Feb 2018 10:02:53 -0800
Message-ID: <b76028c6-c755-8178-2dfc-81c7db1f8bed@infradead.org>
References: <20180216160110.641666320@linux.com>
 <20180216160121.519788537@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20180216160121.519788537@linux.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Christoph Lameter <cl@linux.com>, Mel Gorman <mel@skynet.ie>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, akpm@linux-foundation.org, Thomas Schoebel-Theuer <tst@schoebel-theuer.de>, andi@firstfloor.org, Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@kernel.org>, Guy Shattah <sguy@mellanox.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Michal Nazarewicz <mina86@mina86.com>, Vlastimil Babka <vbabka@suse.cz>, David Nellans <dnellans@nvidia.com>, Laura Abbott <labbott@redhat.com>, Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave.hansen@intel.com>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On 02/16/2018 08:01 AM, Christoph Lameter wrote:
> Control over this feature is by writing to /proc/zoneinfo.
> 
> F.e. to ensure that 2000 16K pages stay available for jumbo
> frames do
> 
> 	echo "2=2000" >/proc/zoneinfo
> 
> or through the order=<page spec> on the kernel command line.
> F.e.
> 
> 	order=2=2000,4N2=500


Please document the the kernel command line option in
Documentation/admin-guide/kernel-parameters.txt.

I suppose that /proc/zoneinfo should be added somewhere in Documentation/vm/
but I'm not sure where that would be.

thanks,
-- 
~Randy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
