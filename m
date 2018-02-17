From: Mike Rapoprt <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC 1/2] Protect larger order pages from breaking up
Date: Sat, 17 Feb 2018 17:07:16 +0100
Message-ID: <CF0D4656-676E-42EA-BB20-C3A557A397C6@linux.vnet.ibm.com>
References: <20180216160110.641666320@linux.com> <20180216160121.519788537@linux.com> <b76028c6-c755-8178-2dfc-81c7db1f8bed@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b76028c6-c755-8178-2dfc-81c7db1f8bed-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mel-wJa12IhQEiizQB+pC5nmwQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On February 16, 2018 7:02:53 PM GMT+01:00, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>On 02/16/2018 08:01 AM, Christoph Lameter wrote:
>> Control over this feature is by writing to /proc/zoneinfo.
>> 
>> F.e. to ensure that 2000 16K pages stay available for jumbo
>> frames do
>> 
>> 	echo "2=2000" >/proc/zoneinfo
>> 
>> or through the order=<page spec> on the kernel command line.
>> F.e.
>> 
>> 	order=2=2000,4N2=500
>
>
>Please document the the kernel command line option in
>Documentation/admin-guide/kernel-parameters.txt.
>
>I suppose that /proc/zoneinfo should be added somewhere in
>Documentation/vm/
>but I'm not sure where that would be.

It's in Documentation/sysctl/vm.txt and in 'man proc' [1]

[1] https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/man5/proc.5

>thanks,

-- 
Sincerely yours,
Mike.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
