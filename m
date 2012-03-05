From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics on
 one opensm server
Date: Mon, 5 Mar 2012 12:51:11 -0800
Message-ID: <20120305125111.9908e77a.weiny2@llnl.gov>
References: <4F4DB11C.5080203@redhat.com>
	<20120229112229.136f25b7.weiny2@llnl.gov>
	<20120302103015.GB6644@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120302103015.GB6644@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2 Mar 2012 12:30:15 +0200
Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> On 11:22 Wed 29 Feb     , Ira Weiny wrote:
> > Doug,
> > 
> > First thanks for this.  Some comments below.
> > 
> > On Wed, 29 Feb 2012 00:01:16 -0500
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > There are two things that stand in the way of opensm being run on
> > > redundant fabrics easily:
> > > 
> > > 1) The opensm init script only starts one instance of opensm and opensm
> > > will only work on one fabric per instance
> > > 2) Even if you start multiple instances, you have to hand modify config
> > > files for each instance and then when you upgrade the opensm rpm you
> > > either loose your modifications or loose getting new default settings
> > > 
> > > I worked around both of these issues, I've attached the files I used to
> > > do so.
> > > 
> > > First, I have an opensm init script that allows starting multiple opensm
> > > instances.  It supports configuring this in one of two ways:
> > > 
> > > 1) Create multiple opensm.conf files, each with a numbered suffix (so
> > > opensm.conf.1, opensm.conf.2, etc.) and it will start one opensm
> > > instance per config file.  This allows an admin to copy the default
> > > config over and edit the things they need, and on rpm upgrade there will
> > > be a new default opensm.conf file so they can diff between their edited
> > > version and the new default and see if there are changes they need to
> > > bring back in.  This also allows for complete flexibility in setting up
> > > the different fabrics, for instance you could use one type of routing on
> > > one and a totally different type on the others.
> > > 
> > > 2) Edit the file /etc/sysconfig/opensm and define more than one GUID in
> > > the GUIDs variable.  This will cause the opensm init script to
> > > automatically start one instance per GUID, passing the GUID in on the
> > > command line.
> > 
> > I know you are going for ease of use here, which is good, however, I worry about this file becoming a redefinition of opensm.conf.
> > 
> > > 
> > > For the most part, this works well.  However, openmpi in particular
> > > doesn't like you to have physically separate fabrics that have the same
> > > subnet_prefix, and you can't specify a subnet_prefix on the command line
> > > to go along with the GUIDs.  So I wrote a patch for that and made the
> > > init script unilaterally increment the subnet prefix for each different
> > > GUID it's attaching to.
> > 
> > If you only allow option 1 above this takes care of itself by making the admin configure his subnet prefixes in each config file as appropriate.  The only down side is the loss of new configuration options as you upgrade.  However, that is probably better taken care of by a default config file with each package.  I mentioned this to Sasha years back and was denied since "you can always generate a new one with '-c'".  :-(
> > 
> > Alex would a default config file be acceptable?  It would mean more work on your part.
> > 
> 
> What the default opensm.conf would be used for? Just as a reference to the
> default values?

Mainly as a reference.  Right now the "-c" option generates the config with options enabled and set to the defaults.  However, most examples I have seen supply the options commented out for the user to comment in what they want set.

This is the method I chose to use in /etc/infiniband-diags/ibdiag.conf.

Another example is httpd.

bash-4.1# rpm -qil httpd | egrep "httpd\.conf"
/etc/httpd/conf/httpd.conf

bash-4.1# head /etc/httpd/conf/httpd.conf
#
# This is the main Apache server configuration file.  It contains the
# configuration directives that give the server its instructions.
# See <URL:http://httpd.apache.org/docs/2.2/> for detailed information.
# In particular, see
# <URL:http://httpd.apache.org/docs/2.2/mod/directives.html>
# for a discussion of each configuration directive.
#
#
# Do NOT simply read the instructions in here without understanding


Ira

> 
> -- Alex


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
