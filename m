From: "Sternberg, Jay E" <jay.e.sternberg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] Remote IB Statistics
Date: Tue, 14 Aug 2012 17:48:48 +0000
Message-ID: <32FB2D14C96F3E428F08393735F7E22023F88E86@FMSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I was asked to develop a way for IB statistics to be accessed on a smart phone
and came up with Remote IB Statistics or rIBs for short and posted the repos
on openfabrics.org for review/comment.

There are four repos associated with this concept.

~jays/ibstatd
   the daemon to be run on a node in the cluster (as root) to allow access to
   a subset of ib commands provided by plugin libraries.  A command line client
   is also included in this repo along with plugins for most if not all the 
   ib commands and the job schedulers slurm and lsf.

~jays/ibuserd
   a subset of ibstatd that does not have plugins and only provides a command
   line interface so systems that do not allow root access to users can do ib
   commands.  E.g. ib ibchecknet

~jays/ribs-android
   a native android app client to connect to the ibstatd daemon.

~jays/ribs-jquery
  an HTML5 client written using jquery to allow connections to the ibstatd 
  daemon from most browsers including those on iPhone and Android phones as
  well as tablets or desktops.

The connection to the daemon is over an ssl socket and certs are exchanges and 
verified to some extent.  This is cleanly an area that could be improved upon.
New plugins could also be added if other job schedulers are needed.

Jay

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
