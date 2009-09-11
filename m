From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Fri, 11 Sep 2009 11:16:44 +0530
Message-ID: <829ded920909102246o18b25caagf84bfe352f699a82@mail.gmail.com>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
	<20090910090213.6888b7d5.weiny2@llnl.gov> <829ded920909102102o49f037cbhc53a849f1fcfdaa4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <829ded920909102102o49f037cbhc53a849f1fcfdaa4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Barry.Mavin-sPOXD9PnZXtBDgjK7y7TUQ@public.gmane.org
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> # ibtracert 10.10.10.1 10.10.10.3

ibtracert only supports source/destination addresses to be specified
in LID/GUID format. See man page of ibtracert.

-
Keshetti Mahesh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
