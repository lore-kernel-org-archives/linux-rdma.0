From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/3] opensm SA DB dump/restore: SA DB persistence
Date: Mon, 02 Nov 2009 12:41:59 +0200
Message-ID: <4AEEB777.5020301@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

OSM can dump SA DB, but it is done every heavy sweep, and
only when running with high verbosity, which cannot be used
in production.
OSM can also load SA DB from file, but then it also stays
in this static SA configuration.

The following patch series improves SA DB persistence:

1/3: Added option to load SA DB only on the first master
     heavy sweep. After that SA goes to the usual (dynamic)
     mode of operation
2/3: Added option to dump SA DB on every sweep (both light
     and heavy), regardless of the verbosity level.
3/3: Optimize SA DB dumping: added 'dirty' flag to the SA
     struct to denote that SA DB was modified since the
     last dump. SA DB will be dumped only if the DB is dirty.

-- Yevgeny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
