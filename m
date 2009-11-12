From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: saquery on ibsim
Date: Thu, 12 Nov 2009 18:30:04 +0530
Message-ID: <829ded920911120500j36749e9fpef51e5021949a778@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I am observing difference in behavior of 'saquery' on real cluster and
ibsim. Whenever I query for path records on cluster using

#saquery -p

it returns path records of all possible source-destination combination.
But when I run the same command on a simulated cluster (ibsim) it
returns only 2-3 path records even though there are many nodes(> 25).

Is there any limitation in ibsim which is not letting the saquery program
retrieve all path records available ?

--
Keshetti Mahesh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
