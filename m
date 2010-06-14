From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: converting ib-mgmt scripts to executables
Date: Mon, 14 Jun 2010 14:46:33 +0300
Message-ID: <20100614114633.GV20172@me>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F64283A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F64283A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

On 09:04 Thu 10 Jun     , Hefty, Sean wrote:
> 
> Before we do the work, would there be any issue converting a couple of the ib-diag scripts to executables?  Specifically, we'd like to have ibchecknet and ibcheckerrors functionality available on Windows.

Basically I don't see any principal issues. The only note is to try to
not have almost duplicated tools (As Ira already said we have
ibqueryerrors tool already).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
