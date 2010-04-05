From: Justin Clift <justin-oNuxUQfTmABg9hUCZPvPmw@public.gmane.org>
Subject: NFS-RDMA on SLES 10 SP3
Date: Tue, 06 Apr 2010 05:53:57 +1000
Message-ID: <4BBA3FD5.8070005@salasaga.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

After discovering that ofa kernel doesn't compile any more (with 1.5.1 
GA and 1.5.2 latest nightly) on SLES 11 with the latest patches, now 
trying on SLES 10 SP3.

I'm attempting to try out NFS-RDMA, however on SLES 10 SP3 it's not 
being presented as an option from the "Custom" list.

i.e.:

   Install rds-tools? [y/N]:n
   Install rnfs-utils? [y/N]:y   <--- this line completely missing
   Install ibutils? [y/N]: ...

Thought I'd better ask if this is expected behaviour before I file a bug 
report, as SLES10 SP3 is specifically mentioned in the NFS-RDMA release
notes as being supported.

?

(I've worked around the above problem by just changing the install.pl 
file.  Compiles fine.  But, thought it best to ask just in case.)

Regards and best wishes,

Justin Clift

-- 
Salasaga  -  Open Source eLearning IDE
               http://www.salasaga.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
