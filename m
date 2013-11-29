From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: IETF draft: RDMA Protocol Extensions
Date: Fri, 29 Nov 2013 11:16:45 +0100
Message-ID: <f1e78b8b394ddacf82f0358b1400e6d6@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I've just seen the following IETF drafts:

- "RDMA Protocol Extensions", draft-ietf-storm-rdmap-ext-08.txt, by
Hemal Shah, Felix Marti, Wael Noureddine, Asgeir Eiriksson and Robert 
Sharp:

http://tools.ietf.org/html/draft-ietf-storm-rdmap-ext-08

"Abstract

    This document specifies extensions to the IETF Remote Direct Memory
    Access Protocol (RDMAP [RFC5040]). RDMAP provides read and write
    services directly to applications and enables data to be transferred
    directly into Upper Layer Protocol (ULP) Buffers without
    intermediate data copies. The extensions specified in this document
    provide the following capabilities and/or improvements: Atomic
    Operations and Immediate Data."
"

5. Atomic Operations
http://tools.ietf.org/html/draft-ietf-storm-rdmap-ext-08#section-5

6. Immediate Data
http://tools.ietf.org/html/draft-ietf-storm-rdmap-ext-08#section-6

- "RDMA Protocol Extensions V2", draft-wood-storm-rdmap-ext-v2-00.txt, 
by
Donald Wood, Robert Sharp and Kenneth Keels:

http://tools.ietf.org/html/draft-wood-storm-rdmap-ext-v2-00

"
Abstract

    This document specifies extensions to the IETF Remote Direct Memory
    Access Protocol and RDMA Protocol Extensions. RDMAP provides read
    and write services directly to applications and enables data to be
    transferred directly into Upper Layer Protocol (ULP) Buffers without
    intermediate data copies. The extensions specified in this document
    provide the following capabilities and/or improvements to eliminate
    application visible differences with other RDMA technologies: Send
    with Immediate Data Operations and a new form of RDMA Read
    Operation.
"

5. Send with Immediate Data Operations:
http://tools.ietf.org/html/draft-wood-storm-rdmap-ext-v2-00#section-5

6. RDMA Read V2:
http://tools.ietf.org/html/draft-wood-storm-rdmap-ext-v2-00#section-6

Is there someone involved in these drafts on the list that could explain
how it will impact Linux RDMA implementation ?

Regards.

-- 
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
